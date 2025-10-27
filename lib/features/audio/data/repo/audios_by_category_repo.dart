import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/audios_model/audios_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class AudiosByCategoryRepo {
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
  });
}

class AudiosByCategoryRepoImpl implements AudiosByCategoryRepo {
  @override
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
  }) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final response = await DioHelper().getData(
      url: ApiEndpoints.audiosByCategory.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.pageSize: 30,
      },
    );

    final AudiosModel audiosModel = AudiosModel.fromJson(response.data);
    return Right(audiosModel);
  }
}
