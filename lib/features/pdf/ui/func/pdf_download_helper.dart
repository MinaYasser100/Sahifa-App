import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';

class PdfDownloadHelper {
  /// Downloads a PDF file from assets and saves it to device storage
  static Future<void> downloadPdfFromAssets({
    required BuildContext context,
    required String assetPath,
    required String fileName,
  }) async {
    try {
      // Check and request storage permission
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await _requestStoragePermission();
        if (!status) {
          if (context.mounted) {
            showErrorToast(
              context,
              'Permission Denied',
              'Storage permission is required to download the file.',
            );
          }
          return;
        }
      }

      // Load the PDF from assets
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // Get the directory to save the file
      Directory? directory;
      if (Platform.isAndroid) {
        // For Android, use Downloads directory
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        // For iOS, use Documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // For other platforms
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        if (context.mounted) {
          showErrorToast(
            context,
            'Error downloading PDF',
            'Unable to access storage folder.',
          );
        }
        return;
      }

      // Create the file path
      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      // Show success message and options
      if (context.mounted) {
        showSuccessToast(
          context,
          'PDF Downloaded',
          'The PDF file has been downloaded',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading PDF: $e');
      }
      if (context.mounted) {
        showErrorToast(context, 'Error downloading', 'An error occurred.');
      }
    }
  }

  /// Request storage permission for Android 13+ and below
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13 (API 33) and above, no need for storage permission for downloads
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        return true;
      }

      // For Android 12 and below
      var status = await Permission.storage.status;
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        status = await Permission.photos.request();
      }
      return status.isGranted;
    }
    return true;
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await Future.value(33); // Default to 33
      return androidInfo;
    }
    return 0;
  }
}
