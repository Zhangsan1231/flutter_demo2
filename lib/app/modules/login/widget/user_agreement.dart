import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAgreement extends StatelessWidget {
  // final RxBool agreementValue;

  const UserAgreement({
    super.key,
    // required this.agreementValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 勾選框
            Checkbox(
              value: false,
              onChanged: (bool? newValue) {
                // if (newValue != null) {
                //   agreementValue.value = newValue;
                // }
              },
              activeColor: Theme.of(context).primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            const SizedBox(width: 8),
            // Text("nihao")

            // 文字區域 - Expanded 保證它不會撐開父容器
            Expanded(

              child: 
              InkWell(
                // 點擊文字區域也能切換勾選
                onTap: () {
                  // agreementValue.value = !agreementValue.value;
                },
                child: RichText(
                  softWrap: true,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
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
          
          ],
        );
  }
}