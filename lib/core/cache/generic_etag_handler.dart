import 'dart:developer';
import 'package:dio/dio.dart';

/// Generic ETag handler for HTTP caching
class GenericETagHandler {
  final String handlerIdentifier; // For logging purposes

  GenericETagHandler({required this.handlerIdentifier});

  /// Prepare headers with ETag for conditional request
  Map<String, dynamic>? prepareHeaders(String? etag, int pageNumber) {
    if (etag == null) {
      log(
        '🆕 [$handlerIdentifier] No ETag for page $pageNumber - First request',
      );
      return null;
    }

    log('🏷️ [$handlerIdentifier] Sending ETag for page $pageNumber: $etag');
    return {'If-None-Match': etag};
  }

  /// Extract ETag from response headers
  String? extractETag(Response response, int pageNumber) {
    final String? etag = response.headers.value('etag');

    if (etag == null) {
      log('⚠️ [$handlerIdentifier] No ETag in response for page $pageNumber');
    }

    return etag;
  }

  /// Check if response is 304 Not Modified
  bool isNotModified(Response response) {
    return response.statusCode == 304;
  }

  /// Log response status
  void logResponseStatus(Response response, int pageNumber) {
    log(
      '📥 [$handlerIdentifier] Response status: ${response.statusCode} for page $pageNumber',
    );
  }
}
