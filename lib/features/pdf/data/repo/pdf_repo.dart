import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';

abstract class PdfRepo {
  Future<Either<String, PdfModel>> getPdf(String dateUtc);
}

class PdfRepoImpl implements PdfRepo {
  final DioHelper _dioHelper;
  PdfRepoImpl(this._dioHelper);

  @override
  Future<Either<String, PdfModel>> getPdf(String dateUtc) async {
    try {
      log('Fetching PDF for date (UTC): $dateUtc');
      log('URL: ${ApiEndpoints.magazinesByDate.path}');

      final response = await _dioHelper.getData(
        url: ApiEndpoints.magazinesByDate.path,
        query: {'date': dateUtc},
      );

      log('PDF fetch successful');
      return Right(PdfModel.fromJson(response.data));
    } catch (e) {
      log('Error fetching PDF: $e');

      // Check if it's a 404 error (date not found)
      if (e.toString().contains('404')) {
        return Left('no_pdf_for_selected_date'.tr());
      }

      return Left('failed_to_fetch_pdf'.tr());
    }
  }
}
