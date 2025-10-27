import 'package:dartz/dartz.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/magazine_model.dart';

abstract class SearchMagazineRepo {
  Future<Either<String, List<MagazineModel>>> searchMagazines({
    required String query,
    required String language,
  });
}

// class SearchMagazineRepoImpl implements SearchMagazineRepo {
//   @override
//   Future<Either<String, List<MagazineModel>>> searchMagazines({
//     required String query,
//     required String language,
//   }) async {

//   }
// }
