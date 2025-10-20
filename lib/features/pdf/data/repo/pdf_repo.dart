import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';

abstract class PdfRepo {
  Future<Either<String, PdfModel>> getPdf(String date);
}

class PdfRepoImpl implements PdfRepo {
  final DioHelper _dioHelper;
  PdfRepoImpl(this._dioHelper);
  @override
  Future<Either<String, PdfModel>> getPdf(String date) async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.magazinesByDate.path,
        query: {'date': date},
      );
      return Right(PdfModel.fromJson(response.data));
    } catch (e) {
      log('Error fetching PDF: $e');
      return Left("Failed to fetch PDF".tr());
    }
  }
}
