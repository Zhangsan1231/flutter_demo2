import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 用户头像组件
/// 
/// 功能说明：
/// 1. 优先显示本地永久缓存头像（Documents/avatars 目录）
/// 2. 本地没有则从网络加载（使用 CachedNetworkImage 自动缓存）
/// 3. 网络加载成功后保存到本地（下次优先走本地）
/// 4. 全部失败显示默认 asset 头像
/// 
/// 支持特性：
/// - 圆形/方形裁剪
/// - 自定义边框
/// - 点击事件（例如放大查看大图）
/// - 尺寸适配（flutter_screenutil）
/// - 加载中/失败占位处理
class UserAvatar extends StatefulWidget {
  /// 后端返回的头像网络路径（完整 URL 或相对路径）
  final String? networkUrl;

  /// 本地已保存的头像路径（可选，如果已知）
  final String? localPath;

  /// 头像显示大小（正方形）
  final double size;

  /// 是否裁剪为圆形（默认 true）
  final bool isCircle;

  /// 可选边框（例如白色描边）
  final BoxBorder? border;

  /// 点击头像时的回调（常用于放大查看大图）
  final VoidCallback? onTap;

  /// 默认头像的 asset 路径（当网络和本地都失败时显示）
  final String defaultAssetPath;

  const UserAvatar({
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
  /// 当前有效的本地头像路径（非空时优先使用 Image.file 显示）
  String? _effectiveLocalPath;

  @override
  void initState() {
    super.initState();
    // 组件初始化时立即尝试加载本地缓存或下载网络图片
    _initLocalPath();
  }

  /// 初始化本地头像路径
  /// 逻辑优先级：
  /// 1. 使用外部传入的 localPath（如果存在且文件真实存在）
  /// 2. 如果有 networkUrl，生成稳定文件名，检查本地是否已有缓存
  /// 3. 本地没有缓存则从网络下载并保存到 Documents/avatars 目录
  /// 4. 保存成功后更新 _effectiveLocalPath，触发 UI 重建
  Future<void> _initLocalPath() async {
    // 优先级1：使用外部传入的本地路径
    if (widget.localPath != null) {
      final file = File(widget.localPath!);
      if (await file.exists()) {
        setState(() => _effectiveLocalPath = widget.localPath);
        return;
      }
    }

    // 获取应用文档目录（永久存储路径，卸载前一直存在）
    final directory = await getApplicationDocumentsDirectory();
    final avatarDir = Directory(p.join(directory.path, 'avatars'));

    // 确保 avatars 子目录存在
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }

    // 如果没有网络 URL，直接结束（后续走默认头像）
    if (widget.networkUrl == null || widget.networkUrl!.isEmpty) return;

    // 生成稳定文件名：同一 URL 始终对应同一本地文件（避免重复下载）
    final fileName = _stableFileName(widget.networkUrl!);
    final file = File(p.join(avatarDir.path, fileName));

    // 已存在本地缓存则直接使用，不再下载
    if (await file.exists()) {
      setState(() => _effectiveLocalPath = file.path);
      return;
    }

    // 开始从网络下载并保存
    try {
      final response = await http.get(
        Uri.parse(_getFullUrl(widget.networkUrl!)),
      );

      // 下载成功（200）则保存到本地
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        setState(() => _effectiveLocalPath = file.path);
      }
    } catch (e) {
      debugPrint('下载头像失败: $e');
      // 下载失败不做额外处理，后续走默认头像
    }
  }

  /// 根据 networkUrl 生成稳定文件名
  /// 逻辑：提取路径 basename + 安全字符替换 + URL hash 后缀
  /// 目的：同一 URL 始终生成相同文件名，避免重复下载和文件冲突
  String _stableFileName(String url) {
    final uri = Uri.tryParse(url);
    final path = uri?.path ?? url;
    final name = path.isEmpty ? url : p.basename(path);
    final safe = name.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final hash = url.hashCode.abs().toRadixString(16);
    return 'avatar_${safe}_$hash.jpg';
  }

  /// 获取完整 URL
  /// 当前项目后端返回的是完整 URL，所以直接返回
  /// 保留此方法以兼容未来可能出现的相对路径
  String _getFullUrl(String? path) => path ?? '';

  @override
  Widget build(BuildContext context) {
    final size = widget.size.w; // 使用 flutter_screenutil 适配尺寸

    Widget imageWidget;

    // 优先级1：本地缓存文件存在
    if (_effectiveLocalPath != null &&
        _effectiveLocalPath!.isNotEmpty &&
        File(_effectiveLocalPath!).existsSync()) {
      imageWidget = Image.file(
        File(_effectiveLocalPath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _defaultAvatar(size),
      );
    }
    // 优先级2：网络加载（带自动缓存）
    else if (widget.networkUrl != null && widget.networkUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: _getFullUrl(widget.networkUrl),
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _loadingPlaceholder(size),
        errorWidget: (context, url, error) => _defaultAvatar(size),
        // 自定义缓存策略：头像缓存 30 天，最多 100 张
        cacheManager: CacheManager(
          Config(
            'avatar_cache',
            stalePeriod: const Duration(days: 30),
            maxNrOfCacheObjects: 100,
          ),
        ),
      );
    }
    // 优先级3：默认头像
    else {
      imageWidget = _defaultAvatar(size);
    }

    // 圆形或圆角裁剪处理
    Widget avatar = widget.isCircle
        ? ClipOval(child: imageWidget)
        : ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imageWidget,
          );

    // 添加边框（如果配置了）
    if (widget.border != null) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          border: widget.border,
        ),
        child: avatar,
      );
    }

    // 支持点击事件（例如放大查看大图）
    if (widget.onTap != null) {
      avatar = GestureDetector(
        onTap: widget.onTap,
        child: avatar,
      );
    }

    // 返回固定尺寸的容器，确保头像区域不会变形
    return SizedBox(
      width: size,
      height: size,
      child: avatar,
    );
  }

  /// 默认头像（本地 asset）
  Widget _defaultAvatar(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(widget.defaultAssetPath),
      backgroundColor: Colors.grey[200],
    );
  }

  /// 网络加载中的占位图（灰色背景 + 加载圈）
  Widget _loadingPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.grey),
        ),
      ),
    );
  }
}