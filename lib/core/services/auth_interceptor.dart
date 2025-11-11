// lib/core/services/auth_interceptor.dart

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sahifa/core/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService _tokenService = TokenService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log(
      '📤 HTTP Request: ${options.method} ${options.path}',
      name: 'AuthInterceptor',
    );

    // Add access token to headers if available
    final token = await _tokenService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      log('🔑 Authorization header added', name: 'AuthInterceptor');
    } else {
      log('⚠️ No access token available', name: 'AuthInterceptor');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized (token expired)
    if (err.response?.statusCode == 401) {
      final refreshed = await _tokenService.refreshAccessToken();

      if (refreshed) {
        try {
          // Get the new access token
          final newToken = await _tokenService.getAccessToken();

          if (newToken == null || newToken.isEmpty) {
            log('❌ No token available after refresh', name: 'AuthInterceptor');
            return handler.next(err);
          }
          // Update the request options with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          // Create a new Dio instance with base configuration for retry
          final retryDio = Dio(
            BaseOptions(
              baseUrl: options.baseUrl,
              headers: {'Content-Type': 'application/json'},
              receiveDataWhenStatusError: true,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              validateStatus: (status) {
                return status != null &&
                    ((status >= 200 && status < 300) || status == 304);
              },
            ),
          );

          // Make the retry request
          final response = await retryDio.fetch(options);
          log(
            '✅ Retry successful with status: ${response.statusCode}',
            name: 'AuthInterceptor',
          );
          return handler.resolve(response);
        } catch (e) {
          log('❌ Retry failed: $e', name: 'AuthInterceptor');

          // Check if it's a DioException with status code
          if (e is DioException && e.response != null) {
            log(
              '❌ Retry error data: ${e.response!.data}',
              name: 'AuthInterceptor',
            );
          }

          return handler.next(err);
        }
      } else {
        log('❌ Token refresh failed, clearing tokens', name: 'AuthInterceptor');
        await _tokenService.clearTokens();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '✅ HTTP Response: ${response.statusCode} ${response.requestOptions.path}',
      name: 'AuthInterceptor',
    );
    log(
      '📊 Response data type: ${response.data.runtimeType}',
      name: 'AuthInterceptor',
    );
    handler.next(response);
  }
}
