// lib/core/helper_network/dio_exception_handler.dart

import 'package:dio/dio.dart';
import 'package:sahifa/core/errors/failures.dart';

class DioExceptionHandler {
  static Failure handleDioException(DioException exception) {
    // Log error for debugging
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(message: 'انتهت مهلة الاتصال بالخادم');

      case DioExceptionType.sendTimeout:
        return NetworkFailure(message: 'انتهت مهلة إرسال البيانات');

      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'انتهت مهلة استقبال البيانات');

      case DioExceptionType.badCertificate:
        return NetworkFailure(message: 'خطأ في شهادة الأمان');

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.cancel:
        return NetworkFailure(message: 'تم إلغاء الطلب');

      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'فشل الاتصال بالإنترنت');

      case DioExceptionType.unknown:
        return NetworkFailure(message: 'حدث خطأ غير متوقع');
    }
  }

  static Failure _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode ?? 0;
    final responseData = exception.response?.data;

    // محاولة استخراج رسالة الخطأ من الـ Response
    String message = 'حدث خطأ في الخادم';

    if (responseData is Map<String, dynamic>) {
      // محاولة استخراج الرسالة من errors array أولاً
      if (responseData['errors'] != null && responseData['errors'] is List) {
        final errors = responseData['errors'] as List;
        if (errors.isNotEmpty) {
          message = errors.first.toString();
        }
      } else {
        // إذا لم يكن هناك errors array، جرب الحقول الأخرى
        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['title'] ??
            message;
      }
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(message: message, statusCode: statusCode);

      case 401:
        return AuthenticationFailure(message: 'يجب تسجيل الدخول أولاً');

      case 403:
        return AuthorizationFailure(
          message:
              message.contains('not authorized') || message.contains('غير مصرح')
              ? message
              : 'ليس لديك صلاحية للوصول',
        );

      case 404:
        return ServerFailure(
          message: 'البيانات المطلوبة غير موجودة',
          statusCode: statusCode,
        );

      case 422:
        return ValidationFailure(
          message: message,
          errors: _extractValidationErrors(responseData),
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: 'خطأ في الخادم، يرجى المحاولة لاحقاً',
          statusCode: statusCode,
        );

      default:
        return ServerFailure(message: message, statusCode: statusCode);
    }
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final errors = <String, List<String>>{};

    // استخراج أخطاء الـ Validation من الـ Response
    if (data.containsKey('errors')) {
      final errorsData = data['errors'];
      if (errorsData is Map<String, dynamic>) {
        errorsData.forEach((key, value) {
          if (value is List) {
            errors[key] = value.map((e) => e.toString()).toList();
          } else {
            errors[key] = [value.toString()];
          }
        });
      }
    }

    return errors.isEmpty ? null : errors;
  }

  static Failure handleGeneralException(Object exception) {
    return ServerFailure(
      message: 'حدث خطأ غير متوقع: ${exception.toString()}',
      statusCode: null,
    );
  }
}
