import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';

abstract class LikePostRepo {
  Future<Either<String, void>> likePost(String postId);
  Future<Either<String, void>> unlikePost(String postId);
}

class LikePostRepoImpl implements LikePostRepo {
  final DioHelper _dioHelper;
  LikePostRepoImpl(this._dioHelper);

  @override
  Future<Either<String, void>> likePost(String postId) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.likePost.withParams({'postId': postId}),
        data: {ApiQueryParams.postId: postId},
      );

      // Handle success response (204 No Content or 200 OK)
      if (response.statusCode == 204 || response.statusCode == 200) {
        return const Right(null);
      }

      return Left('Unexpected response: ${response.statusCode}');
    } on DioException catch (e) {
      // Handle specific HTTP error codes
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      switch (statusCode) {
        case 409:
          // Conflict - Already liked (can happen after token refresh retry)
          // Treat as success since the end result is what we wanted
          return const Right(null);

        case 400:
          // Bad Request - Validation error
          return Left(_extractErrorMessage(responseData, 'Bad Request'));

        case 401:
          // Unauthorized - User not authenticated
          return Left(_extractErrorMessage(responseData, 'Unauthorized'));

        case 404:
          // Not Found - Post doesn't exist
          return Left(_extractErrorMessage(responseData, 'Not Found'));

        case 422:
          // Unprocessable Entity - Validation error
          return Left(
            _extractErrorMessage(responseData, 'Unprocessable Entity'),
          );

        default:
          // Generic error
          return Left(
            _extractErrorMessage(
              responseData,
              'Failed to like post: ${e.message}',
            ),
          );
      }
    } catch (e) {
      // Handle any other unexpected errors
      return Left('Failed to like post: $e');
    }
  }

  @override
  Future<Either<String, void>> unlikePost(String postId) async {
    try {
      final response = await _dioHelper.deleteData(
        url: ApiEndpoints.likePost.withParams({'postId': postId}),
        data: {ApiQueryParams.postId: postId},
      );

      // Handle success response (204 No Content or 200 OK)
      if (response.statusCode == 204 || response.statusCode == 200) {
        return const Right(null);
      }

      return Left('Unexpected response: ${response.statusCode}');
    } on DioException catch (e) {
      // Handle specific HTTP error codes
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      switch (statusCode) {
        case 409:
          // Conflict - Already unliked (treat as success)
          return const Right(null);

        case 400:
          return Left(_extractErrorMessage(responseData, 'Bad Request'));

        case 401:
          return Left(_extractErrorMessage(responseData, 'Unauthorized'));

        case 404:
          return Left(_extractErrorMessage(responseData, 'Not Found'));

        case 422:
          return Left(
            _extractErrorMessage(responseData, 'Unprocessable Entity'),
          );

        default:
          return Left(
            _extractErrorMessage(
              responseData,
              'Failed to unlike post: ${e.message}',
            ),
          );
      }
    } catch (e) {
      return Left('Failed to unlike post: $e');
    }
  }

  /// Extract error message from response data
  /// Tries to get 'message', 'error', or 'detail' from response
  String _extractErrorMessage(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          fallback;
    }
    return fallback;
  }
}
