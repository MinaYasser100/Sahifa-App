import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosHelper {
  static String formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'منذ يوم واحد';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  static Future<void> launchVideoUrl(
    BuildContext context,
    VideoModel video,
  ) async {
    try {
      final Uri url = Uri.parse(video.videoUrl ?? '');

      // Try to launch the URL directly
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        log('Could not launch ${video.videoUrl}');
        showErrorToast(
          context,
          "error".tr(),
          "could_not_launch_the_video_url".tr(),
        );
      }
    } catch (e) {
      log('Error launching video: $e');
      if (context.mounted) {
        showErrorToast(
          context,
          "error".tr(),
          "an_error_occurred_while_opening_the_video".tr(),
        );
      }
    }
  }
}
