import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/details_gallery/data/repo/details_gallery_repo.dart';
import 'package:sahifa/features/details_gallery/manager/details_gallery_cubit/details_gallery_cubit.dart';
import 'package:sahifa/features/details_gallery/ui/widgets/details_gallery_body_view.dart';

class DetailsGalleryView extends StatelessWidget {
  const DetailsGalleryView({super.key, required this.post});

  final ArticleModel post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsGalleryCubit(getIt<DetailsGalleryRepoImpl>())
        ..fetchGalleryDetails(
          categorySlug: post.categorySlug ?? '',
          gallerySlug: post.slug ?? '',
        ),
      child: Scaffold(
        appBar: AppBar(title: Text(post.title ?? 'gallery_details'.tr())),
        body: DetailsGalleryBodyView(
          categorySlug: post.categorySlug ?? '',
          gallerySlug: post.slug ?? '',
        ),
      ),
    );
  }
}
