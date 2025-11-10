import 'package:dio/dio.dart';
import 'package:sahifa/core/services/auth_interceptor.dart';
import 'package:sahifa/env.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  late final Dio _dio;

  DioHelper._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        headers: {'Content-Type': 'application/json'},
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        // Accept 304 Not Modified as valid response for ETag caching
        validateStatus: (status) {
          return status != null &&
              ((status >= 200 && status < 300) || status == 304);
        },
      ),
    );

    // Add Auth Interceptor
    _dio.interceptors.add(AuthInterceptor());
  }

  factory DioHelper() => _instance;

  Dio get dio => _dio;

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: query,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Response> postData({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Response> putData({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  Future<Response> patchData({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to patch data: $e');
    }
  }

  Future<Response> putMultipartData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Create fresh FormData for each request (important for retry logic)
      final formData = FormData.fromMap(data);

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response;
    } on DioException {
      // Re-throw DioException as-is so it can be caught properly
      rethrow;
    } catch (e) {
      throw Exception('Failed to update multipart data: $e');
    }
  }
}
