// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/AIH.png
  AssetGenImage get aih => const AssetGenImage('assets/images/AIH.png');

  /// File path: assets/images/Frame 2102.png
  AssetGenImage get frame2102 =>
      const AssetGenImage('assets/images/Frame 2102.png');

  /// File path: assets/images/Frame-1.png
  AssetGenImage get frame1 => const AssetGenImage('assets/images/Frame-1.png');

  /// File path: assets/images/Frame-10.png
  AssetGenImage get frame10 =>
      const AssetGenImage('assets/images/Frame-10.png');

  /// File path: assets/images/Frame-11.png
  AssetGenImage get frame11 =>
      const AssetGenImage('assets/images/Frame-11.png');

  /// File path: assets/images/Frame-2.png
  AssetGenImage get frame2 => const AssetGenImage('assets/images/Frame-2.png');

  /// File path: assets/images/Frame-3.png
  AssetGenImage get frame3 => const AssetGenImage('assets/images/Frame-3.png');

  /// File path: assets/images/Frame-4.png
  AssetGenImage get frame4 => const AssetGenImage('assets/images/Frame-4.png');

  /// File path: assets/images/Frame-5.png
  AssetGenImage get frame5 => const AssetGenImage('assets/images/Frame-5.png');

  /// File path: assets/images/Frame-6.png
  AssetGenImage get frame6 => const AssetGenImage('assets/images/Frame-6.png');

  /// File path: assets/images/Frame-7.png
  AssetGenImage get frame7 => const AssetGenImage('assets/images/Frame-7.png');

  /// File path: assets/images/Frame-8.png
  AssetGenImage get frame8 => const AssetGenImage('assets/images/Frame-8.png');

  /// File path: assets/images/Frame-9.png
  AssetGenImage get frame9 => const AssetGenImage('assets/images/Frame-9.png');

  /// File path: assets/images/Frame.png
  AssetGenImage get frame => const AssetGenImage('assets/images/Frame.png');

  /// File path: assets/images/Vector.png
  AssetGenImage get vector => const AssetGenImage('assets/images/Vector.png');

  /// File path: assets/images/backgronud.png
  AssetGenImage get backgronud =>
      const AssetGenImage('assets/images/backgronud.png');

  /// File path: assets/images/goggeIcon.png
  AssetGenImage get goggeIcon =>
      const AssetGenImage('assets/images/goggeIcon.png');

  /// File path: assets/images/googe.png
  AssetGenImage get googe => const AssetGenImage('assets/images/googe.png');

  /// File path: assets/images/group.png
  AssetGenImage get group => const AssetGenImage('assets/images/group.png');

  /// File path: assets/images/photo.png
  AssetGenImage get photo => const AssetGenImage('assets/images/photo.png');

  /// File path: assets/images/reminder.png
  AssetGenImage get reminder =>
      const AssetGenImage('assets/images/reminder.png');

  /// File path: assets/images/right.png
  AssetGenImage get right => const AssetGenImage('assets/images/right.png');

  /// File path: assets/images/userPhoto.png
  AssetGenImage get userPhoto =>
      const AssetGenImage('assets/images/userPhoto.png');

  /// File path: assets/images/wechat.png
  AssetGenImage get wechat => const AssetGenImage('assets/images/wechat.png');

  /// File path: assets/images/wechatIcon.png
  AssetGenImage get wechatIcon =>
      const AssetGenImage('assets/images/wechatIcon.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    aih,
    frame2102,
    frame1,
    frame10,
    frame11,
    frame2,
    frame3,
    frame4,
    frame5,
    frame6,
    frame7,
    frame8,
    frame9,
    frame,
    vector,
    backgronud,
    goggeIcon,
    googe,
    group,
    photo,
    reminder,
    right,
    userPhoto,
    wechat,
    wechatIcon,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
