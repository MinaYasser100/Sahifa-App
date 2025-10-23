import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';

abstract class DrawerCategoriesRepo {
  Future<Either<String, List<ParentCategory>>> fetchDrawerCategories(
    String language,
  );
}

class DrawerCategoriesRepoImpl implements DrawerCategoriesRepo {
  final DioHelper _dioHelper;

  DrawerCategoriesRepoImpl(this._dioHelper);
  @override
  Future<Either<String, List<ParentCategory>>> fetchDrawerCategories(
    String language,
  ) async {
    try {
      final result = await _dioHelper.getData(
        url: ApiEndpoints.parentCategories.path,
        query: {ApiQueryParams.language: 1},
      );
      final List<ParentCategory> parentCategories = (result.data as List)
          .map((e) => ParentCategory.fromJson(e))
          .toList();
      return Right(parentCategories);
    } catch (e) {
      return Left("Error fetching drawer categories".tr());
    }
  }
}
