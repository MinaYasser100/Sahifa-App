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
    log(
      '❌ HTTP Error: ${err.response?.statusCode} ${err.message}',
      name: 'AuthInterceptor',
    );
    log('🔍 Error Response: ${err.response?.data}', name: 'AuthInterceptor');

    // Handle 401 Unauthorized (token expired)
    if (err.response?.statusCode == 401) {
      log('🔒 401 Unauthorized - Token expired', name: 'AuthInterceptor');
      log('🔄 Attempting to refresh token...', name: 'AuthInterceptor');

      final refreshed = await _tokenService.refreshAccessToken();

      if (refreshed) {
        log('✅ Token refreshed, retrying request...', name: 'AuthInterceptor');
        try {
          final newToken = await _tokenService.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().fetch(err.requestOptions);
          log('✅ Retry successful', name: 'AuthInterceptor');
          return handler.resolve(response);
        } catch (e) {
          log('❌ Retry failed: $e', name: 'AuthInterceptor');
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
