// lib/core/services/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:sahifa/core/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService _tokenService = TokenService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add access token to headers if available
    final token = await _tokenService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
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
          final newToken = await _tokenService.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        await _tokenService.clearTokens();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
