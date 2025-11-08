import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfNetworkDownloadHelper {
  /// Download PDF from network URL
  static Future<void> downloadPdfFromNetwork({
    required BuildContext context,
    required String pdfUrl,
    required String fileName,
  }) async {
    try {
      // Request storage permission
      final permissionStatus = await _requestStoragePermission();

      if (!permissionStatus) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('storage_permission_denied'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show downloading dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('downloading_pdf...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('unable_to_access_storage_folder'.tr());
      }

      // Create file path
      final filePath = '${directory.path}/$fileName';

      // Download file
      final dio = Dio();
      await dio.download(
        pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint('Download progress: $progress%');
          }
        },
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('pdf_downloaded_successfully'.tr()),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'open'.tr(),
              textColor: Colors.white,
              onPressed: () {
                // TODO: Open file with default app
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_downloading_pdf'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Request storage permission
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.photos.isGranted ||
          await Permission.videos.isGranted) {
        return true;
      }

      // Request permission
      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }

      // For Android 13+, try requesting media permissions
      final photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted) {
        return true;
      }

      return false;
    }

    // For iOS
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
