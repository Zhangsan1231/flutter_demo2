
import 'package:flutter_demo2/app/data/model/my_goal.dart';

class UserModel {
  int? age;
  int? articleViews;
  String? birthdate;
  bool? certificationStatus;
  bool? deviceStatus;
  List<String>? diseaseType;
  String? doctorTitle;
  String? email;
  int? followersNumber;
  int? followingNumber;
  String? gender;
  double? height;
  String? hospital;
  String? hospitalLevel;
  bool? isPersonalizeRecommendation;
  String? location;
  bool? memberTrial;
  int? membershipId;
  String? membershipName;
  String? name;
  String? phone;
  String? photo;
  Preferences? preferences;
  List<String>? tags;
  String? userId;
  String? uuid;
  int? vipActiveTime;
  int? vipEndDate;
  int? vipStartDate;
  bool? vipStatus;
  double? weight;
  MyGoalClass? target;

  UserModel({
    this.age,
    this.articleViews,
    this.birthdate,
    this.certificationStatus,
    this.deviceStatus,
    this.diseaseType,
    this.doctorTitle,
    this.email,
    this.followersNumber,
    this.followingNumber,
    this.gender,
    this.height,
    this.hospital,
    this.hospitalLevel,
    this.isPersonalizeRecommendation,
    this.location,
    this.memberTrial,
    this.membershipId,
    this.membershipName,
    this.name,
    this.phone,
    this.photo,
    this.preferences,
    this.tags,
    this.userId,
    this.uuid,
    this.vipActiveTime,
    this.vipEndDate,
    this.vipStartDate,
    this.vipStatus,
    this.weight,
    this.target,  // 添加目标参数
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // print("查看json");
    // print(json);
    return UserModel(
      age: json['age'],
      articleViews: json['article_views'],
      birthdate: json['birthdate'],
      certificationStatus: json['certification_status'],
      deviceStatus: json['device_status'],
      diseaseType: json['disease_type'] != null
          ? List<String>.from(json['disease_type'])
          : null,
      doctorTitle: json['doctor_title'],
      email: json['email'],
      followersNumber: json['followers_number'],
      followingNumber: json['following_number'],
      gender: json['gender'],
      height: json['height']?.toDouble(),
      hospital: json['hospital'],
      hospitalLevel: json['hospital_level'],
      isPersonalizeRecommendation: json['isPersonalizeRecommendation'],
      location: json['location'],
      memberTrial: json['member_trial'],
      membershipId: json['membership_id'],
      membershipName: json['membership_name'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo'],
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      userId: json['user_id'],
      uuid: json['uuid'],
      vipActiveTime: json['vip_active_time'],
      vipEndDate: json['vip_end_date'],
      vipStartDate: json['vip_start_date'],
      vipStatus: json['vip_status'],
      weight: json['weight']?.toDouble(),
      target: json['target'] != null 
          ? MyGoalClass.fromJson(json['target'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'article_views': articleViews,
      'birthdate': birthdate,
      'certification_status': certificationStatus,
      'device_status': deviceStatus,
      'disease_type': diseaseType,
      'doctor_title': doctorTitle,
      'email': email,
      'followers_number': followersNumber,
      'following_number': followingNumber,
      'gender': gender,
      'height': height,
      'hospital': hospital,
      'hospital_level': hospitalLevel,
      'isPersonalizeRecommendation': isPersonalizeRecommendation,
      'location': location,
      'member_trial': memberTrial,
      'membership_id': membershipId,
      'membership_name': membershipName,
      'name': name,
      'phone': phone,
      'photo': photo,
      'preferences': preferences?.toJson(),
      'tags': tags,
      'user_id': userId,
      'uuid': uuid,
      'vip_active_time': vipActiveTime,
      'vip_end_date': vipEndDate,
      'vip_start_date': vipStartDate,
      'vip_status': vipStatus,
      'weight': weight,
      'target': target?.toJson(),
    };
  }

  isEmpty(){
    if(uuid == null || target == null){
      return true;
    }else return false;
  }
}

class Preferences {
  String? bloodSugarUnit;
  String? heightUnit;
  String? tempurateUnit;
  String? weightUnit;

  Preferences({
    this.bloodSugarUnit,
    this.heightUnit,
    this.tempurateUnit,
    this.weightUnit,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      bloodSugarUnit: json['blood_sugar_unit'],
      heightUnit: json['height_unit'],
      tempurateUnit: json['tempurate_unit'],
      weightUnit: json['weight_unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_sugar_unit': bloodSugarUnit,
      'height_unit': heightUnit,
      'tempurate_unit': tempurateUnit,
      'weight_unit': weightUnit,
    };
  }
}