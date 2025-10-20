import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/magazine_model.dart';

abstract class MagazinesRepo {
  Future<Either<String, MagazineModel>> getMagazines({required int pageNumber});
}

class MagazinesRepoImpl implements MagazinesRepo {
  final DioHelper _dioHelper;
  MagazinesRepoImpl(this._dioHelper);
  @override
  Future<Either<String, MagazineModel>> getMagazines({
    required int pageNumber,
  }) async {
    try {
      // Call the data source to get the magazines
      final response = await _dioHelper.getData(
        url: ApiEndpoints.magazines.path,
        query: {'pageNumber': pageNumber, 'pageSize': 30},
      );
      // Ensure response.data is a Map
      final jsonData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : throw Exception(
              'Invalid response format: expected Map but got ${response.data.runtimeType}',
            );

      final MagazineModel magazineModel = MagazineModel.fromJson(jsonData);
      return Right(magazineModel);
    } catch (e) {
      log('Error fetching magazines: $e');
      return Left('Failed to fetch magazines: $e');
    }
  }
}
