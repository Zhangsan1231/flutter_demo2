import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/service/storage_service.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:flutter_demo2/app/modules/login/controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UserAgreement extends StatelessWidget {
  // final RxBool agreementValue;

  const UserAgreement({
    super.key,
    // required this.agreementValue,
  });

  @override
  Widget build(BuildContext context) {
    bool? argumengKV = SecureStorageService().getBool(AppValues.agreementValue);

    RxBool value = argumengKV != null ? argumengKV.obs : false.obs;

    // bool agreementValue = false;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 41 - 25.w, left: 41 - 25.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 勾選框
              Obx(
                () => Checkbox(
                  value: value.value,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      print('点击测试');
                      SecureStorageService().setBool(
                        AppValues.agreementValue,
                        newValue,
                      );
                      value.value = newValue;
                      print(AppValues.agreementValue);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              const SizedBox(width: 8),
              // Text("nihao")

              // 文字區域 - Expanded 保證它不會撐開父容器
              Expanded(
                child: InkWell(
                  // 點擊文字區域也能切換勾選
                  onTap: () {
                    // agreementValue.value = !agreementValue.value;
                  },
                  child: RichText(
                    textAlign: TextAlign.left,
                    softWrap: true,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        height: 1.4, // 行高更舒適
                      ),
                      children: [
                        const TextSpan(text: "I have read and agree to the "),
                        TextSpan(
                          text: "User Agreement",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Open User Agreement");
                              // Get.toNamed('/user-agreement');
                            },
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Open Privacy Policy");
                              // Get.toNamed('/privacy-policy');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Gap(20.h),
            ],
          ),
        ),
        Gap(20.h),
      ],
    );
  }
}
