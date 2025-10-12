// import 'package:dio/dio.dart';

// class DioHelper {
//   static final DioHelper _instance = DioHelper._internal();
//   late final Dio _dio;

//   DioHelper._internal() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: AppConst.baseUrl,
//         headers: {'Content-Type': 'application/json'},
//         receiveDataWhenStatusError: true,
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ),
//     );
//   }

//   factory DioHelper() => _instance;

//   Dio get dio => _dio;

//   Future<Response> getData({
//     required String url,
//     Map<String, dynamic>? query,
//   }) async {
//     try {
//       final response = await _dio.get(url, queryParameters: query);
//       return response;
//     } catch (e) {
//       throw Exception('Failed to fetch data: $e');
//     }
//   }

//   Future<Response> postData({
//     required String url,
//     required Map<String, dynamic>? data,
//   }) async {
//     try {
//       final response = await _dio.post(url, data: data);
//       return response;
//     } catch (e) {
//       throw Exception('Failed to post data: $e');
//     }
//   }
// }
