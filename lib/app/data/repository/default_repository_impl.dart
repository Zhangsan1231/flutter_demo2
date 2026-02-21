import 'dart:io';

// import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter_platform_interface/src/credentials.dart';
import 'package:flutter_demo2/app/core/base/base_repository.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/data/model/my_goal.dart';
import 'package:flutter_demo2/app/data/model/user_model.dart';
import 'package:flutter_demo2/app/data/repository/default_repository.dart';
import 'package:flutter_demo2/app/network/api/api.dart';
import 'package:flutter_demo2/app/network/dio_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_demo2/app/network/exceptions/api_exception.dart';

class DefaultRepositoryImpl extends BaseRepository
    implements DefaultRepository {
  @override
  Future<UserModel?> getInfo() {
    // TODO: implement getInfo
    var uri = DioProvider.baseUrl + Api.infoApi;
    var dioCall = dioClient.get(uri);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseInfoResponse(response));
    } catch (e) {
      //  logger.e('获取用户信息失败:$e');
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(
          httpCode: -1,
          status: 'Parse Error',
          message: '数据解析失败',
        );
      }
    }
  }

  @override
  Future<void> postInfo([UserModel? user]) {
    var uri = DioProvider.baseUrl + Api.infoApi;
    var dioCall;
    // 从 storage 获取用户 uuid
    String? uuid = storage.getString(AppValues.accessToken);
    var myData = {
      "uuid": uuid ?? "",
      "name": "defualtName",
      "age": 18,
      "gender": "U",
      "height": 0.0,
      "weight": 0.0,
      "photo": "",
      "birthdate": "2025-01-01",
      "phone": "",
      "email": "",
      "location": "",
      "followers_number": 0,
      "following_number": 0,
      "article_views": 0,
      "device_status": false,
      "disease_type": [],
      "certification_status": false,
      "doctor_title": "",
      "hospital_level": "",
      "hospital": "",
      "membership_id": -1,
      "membership_name": "free",
      "vip_active_time": 0,
      "vip_end_date": 0,
      "vip_start_date": 0,
      "member_trial": false,
      "vip_status": false,
      "isPersonalizeRecommendation": false,
      "preferences": {
        "height_unit": "I",
        "weight_unit": "I",
        "tempurate_unit": "I",
        "blood_sugar_unit": "I",
      },
      "tags": [],
      "target": MyGoalClass(
        step: 6000,
        bloodPressure: [80, 100],
        bloodGlucose: BloodGlucoseSub(
          wakeUp: GlucoseSub(timeRange: ["06AM-07AM"], values: [0]),
          breakfast: GlucoseSub(
            timeRange: ["07AM-09AM", "09AM-11AM"],
            values: [0, 0],
          ),
          lunch: GlucoseSub(
            timeRange: ["11AM-01PM", "01PM-05PM"],
            values: [0, 0],
          ),
          dinner: GlucoseSub(
            timeRange: ["05PM-07PM", "07PM-08PM"],
            values: [0, 0],
          ),
          bedtime: GlucoseSub(timeRange: ["08PM-10PM"], values: [0]),
          midnight: GlucoseSub(timeRange: ["10PM-06AM"], values: [0]),
        ),
        reminders: [120, 60],
      ),
    };
    if (user == null) {
      // logger.d("创建用户");
      // logger.d(myData.toString());
      // logger.d("target");
      // logger.d(myData["target"].toString());
      dioCall = dioClient.post(uri, queryParameters: {'type': 0}, data: myData);
    } else {
      dioCall = dioClient.post(
        uri,
        queryParameters: {'type': 0},
        data: {
          "name": user.name,
          "age": user.age,
          "gender": user.gender,
          "height": user.height,
          "weight": user.weight,
          "photo": user.photo,
          "birthdate": user.birthdate,
          "phone": user.phone,
          "email": user.email,
          "location": user.location,
          "followers_number": user.followersNumber,
          "following_number": user.followingNumber,
          "article_views": user.articleViews,
          "device_status": user.deviceStatus,
          "disease_type": user.diseaseType,
          "certification_status": user.certificationStatus,
          "doctor_title": user.doctorTitle,
          "hospital_level": user.hospitalLevel,
          "hospital": user.hospital,
          "membership_id": user.membershipId,
          "membership_name": user.membershipName,
          "vip_active_time": user.vipActiveTime,
          "vip_end_date": user.vipEndDate,
          "vip_start_date": user.vipStartDate,
          "member_trial": user.memberTrial,
          "vip_status": user.vipStatus,
          "isPersonalizeRecommendation": user.isPersonalizeRecommendation,
          "preferences": user.preferences,
          "tags": user.tags,
        },
      );
    }
    // logger.d(myData.toString());

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseInfoResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  /// 解析用户信息接口的响应数据
  ///
  /// 该方法用于处理 /info 接口（或类似用户信息提交/更新接口）的响应
  /// 根据后端返回的 code 判断是否成功，并尝试将 data 字段解析为 UserModel
  ///
  /// [response] Dio 请求返回的原始响应对象（dynamic 类型，实际为 Map 或 JSON 对象）
  ///
  /// 返回值：
  /// - UserModel? 成功时返回解析后的用户模型
  /// - null 失败时（code == 0 或解析异常）返回 null
  UserModel? _parseInfoResponse(dio.Response<dynamic> response) {
    // 检查响应是否成功（code != 0 表示成功，code == 0 表示业务失败）
    // 注意：这里假设后端约定 code == 0 为失败，其他值为成功
    // 如果你的后端约定不同（如 code == 200 为成功），需要修改条件
    if (response.data["code"] == 0) {
      // 业务失败情况：打印详细信息用于调试
      // logger.d("查看response.dataUserinfo"); // 调试标签：查看用户信息相关响应
      // logger.d("响应消息: ${response.data["msg"]}"); // 打印后端返回的失败消息
      // logger.d("返回数据: ${response.data["data"]}"); // 打印 data 字段（可能为空或错误信息）

      // 返回 null 表示本次操作未成功获取用户信息
      return null;
    }

    // 业务成功情况：尝试解析 data 字段为 UserModel
    try {
      // 假设后端返回格式为 { "code": xxx, "msg": "...", "data": {用户字段...} }
      // 这里直接取 data 字段并用 fromJson 转换为 UserModel
      final userData = response.data["data"];

      if (userData == null) {
        logger.w("响应 data 字段为空，无法解析 UserModel");
        return null;
      }

      // 使用模型类的 fromJson 方法进行反序列化
      // 确保 UserModel 已正确实现 fromJson（通常用 json_serializable 生成）
      return UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      // 解析失败（字段缺失、类型不匹配、JSON 格式错误等）
      // logger.e("解析 UserModel 失败", error: e, stackTrace: stackTrace);
      // logger.d("原始响应 data: ${response.data["data"]}");

      // 解析异常时返回 null，避免上层崩溃
      return null;
    }
  }

  @override
  Future<bool> patchInfo(Map<String, Object> map) async {
    var uri = DioProvider.baseUrl + Api.infoApi;
    var dioCall = dioClient.patch(uri, queryParameters: {'type': 0}, data: map);
    try {
      return callApiWithErrorParser(dioCall).then((response) {
        if (response.data['code'] == 1) {
          logger.d('修改成功');
          return true;
        } else {
          logger.d('修改失败');
          return false;
        }
      });
    } catch (e) {
      logger.d('patchinfo 异常:$e');
      rethrow;
    }
  }

 // 在 DefaultRepositoryImpl.dart 中修改 uploadImage 方法
@override
Future<String?> uploadImage(
  File file, {
  Function(double progress)? onProgress,   // ← 新增进度回调
}) async {
  var uri = DioProvider.domesticBaseUrl + Api.imageApi;

  var formData = dio.FormData.fromMap({
    'file': await dio.MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });

  try {
    final response = await dioClient.post(
      uri,
      data: formData,
      onSendProgress: (int sent, int total) {
        if (total > 0 && onProgress != null) {
          final progress = sent / total;
          onProgress(progress);        // ← 实时回调进度（0.0 ~ 1.0）
        }
      },
    );

    if (response.data['code'] == 1) {
      return response.data['data'];   // 返回图片 URL
    }
    return null;
  } catch (e) {
    logger.e('上传图片失败: $e');
    rethrow;
  }
}
}
