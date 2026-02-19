
import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/core/values/app_colors.dart';
import 'package:flutter_demo2/app/core/values/app_values.dart';
import 'package:get/get.dart';


class DialogUtil {
  /// 显示权限设置对话框
  static Future<bool?> showPermissionDialog(BuildContext context, String permissionName) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.radius),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(AppValues.margin),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppValues.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  padding: EdgeInsets.all(AppValues.margin),
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security,
                    color: AppColors.colorPrimary,
                    size: 32,
                  ),
                ),
                SizedBox(height: AppValues.margin),
                
                // 标题
                // Text(
                //   T.permissionRequest.tr,
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black87,
                //   ),
                // ),
                SizedBox(height: AppValues.margin),
                
                // 内容
                // Text(
                //   T.permissionRequestContent.trArgs([permissionName]),
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.black54,
                //   ),
                // ),
                SizedBox(height: AppValues.margin_20),
                
                // 按钮
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     // 取消按钮
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () => Navigator.of(context).pop(false),
                //         style: TextButton.styleFrom(
                //           padding: EdgeInsets.symmetric(vertical: AppValues.margin),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(AppValues.smallRadius),
                //             side: BorderSide(color: Colors.grey.shade300),
                //           ),
                //         ),
                //         child: Text(
                //           T.cancel.tr,
                //           style: TextStyle(
                //             color: Colors.black54,
                //             fontSize: 16,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: AppValues.margin),
                //     // 去设置按钮
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: () {
                //           Navigator.of(context).pop(true);
                //         },
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: AppColors.colorPrimary,
                //           padding: EdgeInsets.symmetric(vertical: AppValues.margin),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(AppValues.smallRadius),
                //           ),
                //           elevation: 0,
                //         ),
                //         child: Text(
                //           T.goToSettings.tr,
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
             
             
              ],
            ),
          ),
        );
      },
    );
  }
} 