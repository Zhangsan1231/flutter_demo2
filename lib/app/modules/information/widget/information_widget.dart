import 'package:flutter/material.dart';
import 'package:flutter_demo2/app/modules/information/controllers/information_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class InformationWidget extends StatefulWidget {
  InformationWidget({Key? key}) : super(key: key);

  @override
  _InformationWidgetState createState() => _InformationWidgetState();
}

Widget firstTextInput() {
  final controller = Get.find<InformationController>();

  return TextField(
    controller: controller.firstNameController,
    decoration: InputDecoration(
      filled: true,
      fillColor: Color(0xffF5F6FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.w),
        borderSide: BorderSide.none,
      ),
      hintText: 'First name',
    ),
  );
}

Widget lastTextInput() {
  final controller = Get.find<InformationController>();

  return TextField(
    controller: controller.lastNameController,
    decoration: InputDecoration(
      filled: true,
      fillColor: Color(0xffF5F6FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.w),
        borderSide: BorderSide.none,
      ),
      hintText: 'Last name',
    ),
  );
}

class _InformationWidgetState extends State<InformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: null);
  }
}
