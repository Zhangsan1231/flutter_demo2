import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_demo2/gen/assets.gen.dart';

class UserAvatar extends StatefulWidget {
  final String? networkUrl; // 后端返回的网络路径（完整 URL 或相对路径）
  final String? localPath; // 本地已保存路径（可选，如果已知）
  final double size; // 头像大小（正方形）
  final bool isCircle; // 是否圆形（默认 true）
  final BoxBorder? border; // 可选边框
  final VoidCallback? onTap; // 点击事件（可选放大查看）
  final String defaultAssetPath; // 默认头像 asset 路径
  UserAvatar({
    Key? key,
    this.networkUrl,
    this.localPath,
     this.size = 60,
     this.isCircle = true,
    this.border,
    this.onTap,
    this.defaultAssetPath = 'assets/images/userPhoto.png',
  }) : super(key: key);
  


  @override
  _UserAvatarState createState() => _UserAvatarState();
}


class _UserAvatarState extends State<UserAvatar> {
  final RxString _effectiveLocalPath = ''.obs;
  //初始化本地路径 优先用传递的路径 尝试从网络下载
Future<void> _initLocalPath() async{
  if(widget.localPath != null && await File(widget.localPath!).exists()){
    _effectiveLocalPath.value = widget.localPath!;
    return;
  }
  // 2. 获取 Documents 目录
    // final directory = await getApplicationDocumentsDirectory();
    // final avatarDir = Directory(p.join(directory.path, 'avatars'));
    // if (!await avatarDir.exists()) {
    //   await avatarDir.create(recursive: true);
    // }

}
  @override
  Widget build(BuildContext context) {
    return Container(child: null);
  }
}
