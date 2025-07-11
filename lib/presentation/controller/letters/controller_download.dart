import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ControllerDownload extends GetxController {
  static ControllerDownload get to => Get.find();

  final Dio _dio = Dio();
  final RxDouble progress = 0.0.obs;
  final RxBool isDownloading = false.obs;
  final RxString downloadStatus = "".obs;
  final RxString filePath = "".obs;

  // Map to keep track of ongoing downloads
  final Map<String, CancelToken> _downloadTasks = {};

  @override
  void onInit() {
    super.onInit();
    // Initialize any required setup here
  }

  // Start a download with unique ID (you can use url or filename as ID)
  Future<void> downloadSurat(String url, String fileName) async {
    final String downloadId = fileName; // Use filename as unique identifier

    try {
      // If already downloading this file, just return
      if (_downloadTasks.containsKey(downloadId)) {
        Get.snackbar('Info', 'File ini sedang diunduh');
        return;
      }

      isDownloading.value = true;
      downloadStatus.value = "Mempersiapkan unduhan...";
      progress.value = 0.0;

      String? savePath;

      if (Platform.isAndroid) {
        savePath = await _getAndroidDownloadPath(fileName);
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        savePath = '${directory.path}/$fileName.pdf';
      }

      if (savePath == null) {
        isDownloading.value = false;
        downloadStatus.value = "Direktori unduhan tidak tersedia";
        return;
      }

      filePath.value = savePath;

      // Create a CancelToken for this download
      final CancelToken cancelToken = CancelToken();
      _downloadTasks[downloadId] = cancelToken;

      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            downloadStatus.value =
                "${(progress.value * 100).toStringAsFixed(0)}%";
          }
        },
      );

      // Download completed successfully
      _downloadTasks.remove(downloadId);
      isDownloading.value = false;
      downloadStatus.value = "Unduhan selesai";

      // Show notification that download is complete
      Get.snackbar(
        'Unduhan Selesai',
        'File $fileName telah berhasil diunduh',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Open the downloaded file
      final result = await OpenFile.open(savePath);
      if (result.type != ResultType.done) {
        downloadStatus.value = "Gagal membuka file: ${result.message}";
      }
    } catch (e) {
      // Remove from ongoing downloads if error occurs
      _downloadTasks.remove(downloadId);

      // Check if it was cancelled intentionally
      if (e is DioError && e.type == DioErrorType.cancel) {
        isDownloading.value = false;
        downloadStatus.value = "Unduhan dibatalkan";
        return;
      }

      isDownloading.value = false;
      downloadStatus.value = "Gagal mengunduh: ${e.toString()}";
      print("Download error: $e");

      // Show error notification
      Get.snackbar(
        'Gagal Mengunduh',
        'Terjadi kesalahan saat mengunduh file',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Method to cancel a specific download
  void cancelDownload(String fileName) {
    final String downloadId = fileName;
    if (_downloadTasks.containsKey(downloadId)) {
      _downloadTasks[downloadId]?.cancel("Download cancelled by user");
      _downloadTasks.remove(downloadId);

      isDownloading.value = false;
      downloadStatus.value = "Unduhan dibatalkan";
    }
  }

  // Method to cancel all downloads
  void cancelAllDownloads() {
    _downloadTasks.forEach((id, token) {
      token.cancel("All downloads cancelled");
    });
    _downloadTasks.clear();

    isDownloading.value = false;
    downloadStatus.value = "Semua unduhan dibatalkan";
  }

  Future<String?> _getAndroidDownloadPath(String fileName) async {
    // Check Android version
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt < 29) {
      // For Android below 10, we need storage permission
      var status = await Permission.storage.request();
      if (status.isGranted) {
        final downloadPath = await AndroidPathProvider.downloadsPath;
        return '$downloadPath/$fileName.pdf';
      } else {
        Get.snackbar(
            'Izin ditolak', 'Izin penyimpanan diperlukan untuk menyimpan file');
        return null;
      }
    } else {
      // For Android 10+, we can use Downloads directory without explicit permission
      try {
        final directory = await getExternalStorageDirectory();
        return directory != null ? '${directory.path}/$fileName.pdf' : null;
      } catch (e) {
        print("Error getting downloads path: $e");
        // Fallback to app's external storage
        final directory = await getExternalStorageDirectory();
        return directory != null ? '${directory.path}/$fileName.pdf' : null;
      }
    }
  }

  @override
  void onClose() {
    // No need to cancel downloads when controller is closed
    // We want downloads to continue in background
    super.onClose();
  }
}
