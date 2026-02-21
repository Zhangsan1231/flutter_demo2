// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// /// 自定義的網路圖片緩存組件（類似 CachedNetworkImage 的簡化版）
// /// 
// /// 主要特點：
// /// - 優先從本地緩存讀取圖片（Image.file），支援離線顯示、最快速度、無網路請求
// /// - 無本地緩存時：顯示佔位符 + 後台靜默下載並保存到本地
// /// - 下載成功後：自動切換顯示本地檔案（無需手動刷新）
// /// - 下載失敗時：回退使用 Image.network 顯示（確保圖片盡可能出現）
// /// - 不使用任何 Rx 變數或狀態管理依賴，全部邏輯封裝在組件內部
// /// - 支援 imageUrl 動態變化（透過 didUpdateWidget 自動重新檢查/下載）
// /// 
// /// 使用建議：
// /// 適合放在 Obx / GetBuilder 中，當 imageUrl 變化時會自動重新處理緩存
// class CustomCachedNetworkImage extends StatefulWidget {
//   /// 圖片網路 URL（必須傳入）
//   final String imageUrl;

//   /// 圖片顯示寬度（可選）
//   final double? width;

//   /// 圖片顯示高度（可選）
//   final double? height;

//   /// 圖片適配模式，預設 BoxFit.cover
//   final BoxFit? fit;

//   /// 載入中或佔位時顯示的 widget（預設顯示 CircularProgressIndicator）
//   final Widget? placeholder;

//   /// 載入失敗時顯示的 widget（預設顯示錯誤圖標）
//   final Widget? errorWidget;

//   const CustomCachedNetworkImage({
//     super.key, // 使用 super.key 符合新版 Flutter 推薦
//     required this.imageUrl,
//     this.width,
//     this.height,
//     this.fit = BoxFit.cover,
//     this.placeholder,
//     this.errorWidget,
//   });

//   @override
//   State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImageState();
// }

// class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage> {
//   /// 用來保存當前圖片的緩存檢查/下載 Future
//   /// late 確保在 initState 中初始化
//   late Future<File?> _cacheFuture;

//   @override
//   void initState() {
//     super.initState();
//     // 組件首次創建時，立即開始檢查/下載緩存
//     _cacheFuture = _ensureCached(widget.imageUrl);
//   }

//   @override
//   void didUpdateWidget(covariant CustomCachedNetworkImage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // 當外部傳入的 imageUrl 發生變化時，重新觸發緩存檢查與下載
//     if (oldWidget.imageUrl != widget.imageUrl) {
//       _cacheFuture = _ensureCached(widget.imageUrl);
//     }
//   }

//   /// 核心方法：確保圖片被緩存到本地
//   /// 1. 先檢查本地是否已有檔案
//   /// 2. 如果沒有，則嘗試從網路下載並保存
//   /// 3. 返回本地 File（成功）或 null（失敗）
//   Future<File?> _ensureCached(String url) async {
//     // 空 URL 直接返回 null
//     if (url.isEmpty) return null;

//     // 獲取對應的本地檔案路徑
//     final file = await _getLocalFile(url);

//     // 如果本地檔案已存在，直接返回（最快路徑）
//     if (await file.exists()) {
//       return file;
//     }

//     // 本地不存在 → 嘗試網路下載
//     try {
//       final response = await http.get(Uri.parse(url));

//       // 只處理 200 成功的響應
//       if (response.statusCode == 200) {
//         // 確保父目錄存在（遞迴創建）
//         await file.parent.create(recursive: true);
//         // 將下載的 bytes 寫入本地檔案
//         await file.writeAsBytes(response.bodyBytes);
//         return file;
//       }
//       // 非 200 狀態碼視為失敗，靜默忽略
//     } catch (_) {
//       // 網路錯誤、超時、格式錯誤等全部靜默處理
//       // （可根據需求改為記錄 log）
//     }

//     // 下載失敗或異常，返回 null
//     return null;
//   }

//   /// 根據 URL 生成唯一的本地檔案路徑
//   /// 使用 url.hashCode 作為檔名（簡單但可能有極低機率衝突）
//   /// 所有緩存圖片統一放在應用文檔目錄下的 image_cache 子目錄
//   Future<File> _getLocalFile(String url) async {
//     // 獲取應用私有文檔目錄（永久保存，不易被系統清理）
//     final directory = await getApplicationDocumentsDirectory();
    
//     // 自訂緩存子目錄
//     final cacheDir = Directory('${directory.path}/image_cache');
    
//     // 如果目錄不存在，創建它
//     if (!await cacheDir.exists()) {
//       await cacheDir.create(recursive: true);
//     }

//     // 使用 URL 的 hashCode 作為檔名（絕對值，避免負數問題）
//     final fileName = url.hashCode.abs().toString();
    
//     // 最終檔案路徑
//     return File('${cacheDir.path}/$fileName');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<File?>(
//       // 綁定上面計算的緩存 Future
//       future: _cacheFuture,
      
//       builder: (context, snapshot) {
//         // 情況1：正在檢查緩存或下載中（ConnectionState.waiting）
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // 顯示自訂佔位符或預設的轉圈
//           return widget.placeholder ??
//               const Center(child: CircularProgressIndicator());
//         }

//         // 情況2：緩存檢查完成，且有有效的本地檔案 → 優先使用 Image.file
//         if (snapshot.hasData && snapshot.data != null) {
//           return Image.file(
//             snapshot.data!, // 本地檔案
//             width: widget.width,
//             height: widget.height,
//             fit: widget.fit,
//             // 避免切換時閃爍（尤其在 url 變化時）
//             gaplessPlayback: true,
//             // 本地檔案也可能損壞或被刪除，添加錯誤回退
//             errorBuilder: (_, __, ___) =>
//                 widget.errorWidget ?? const Icon(Icons.error),
//           );
//         }

//         // 情況3：URL 為空 → 直接顯示佔位符
//         if (widget.imageUrl.isEmpty) {
//           return widget.placeholder ?? const SizedBox.shrink();
//         }

//         // 情況4：緩存失敗 → 回退使用 Image.network 顯示原始網路圖片
//         return Image.network(
//           widget.imageUrl,
//           width: widget.width,
//           height: widget.height,
//           fit: widget.fit,
//           // 顯示下載進度（可選）
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return widget.placeholder ??
//                 const Center(child: CircularProgressIndicator());
//           },
//           // 網路也失敗時顯示錯誤 widget
//           errorBuilder: (_, __, ___) =>
//               widget.errorWidget ?? const Icon(Icons.error),
//         );
//       },
//     );
//   }
// }