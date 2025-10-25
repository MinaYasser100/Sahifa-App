import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sahifa/core/model/parent_category/subcategory.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/features/home/data/repo/articles_drawer_subcategory_repo.dart';
import 'package:sahifa/features/home/manger/articles_drawer_subcategory_cubit/articles_drawer_subcategory_cubit.dart';

import 'drawer_subcategory_content_bloc_builder.dart';

class DrawerSubCategoryContentView extends StatefulWidget {
  const DrawerSubCategoryContentView({super.key, required this.subcategory});
  final SubcategoryInfoModel subcategory;

  @override
  State<DrawerSubCategoryContentView> createState() =>
      _DrawerSubCategoryContentViewState();
}

class _DrawerSubCategoryContentViewState
    extends State<DrawerSubCategoryContentView> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients && !_isLoadingMore) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = maxScroll * 0.8; // 80% threshold

      if (currentScroll >= threshold) {
        final cubit = context.read<ArticlesDrawerSubcategoryCubit>();
        final state = cubit.state;

        if (state is ArticlesDrawerSubcategoryLoaded && state.hasMore) {
          _isLoadingMore = true;

          final language = LanguageHelper.getCurrentLanguageCode(context);
          cubit
              .loadMoreArticles(
                categorySlug: widget.subcategory.slug ?? '',
                language: language,
              )
              .then((_) {
                if (mounted) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          ArticlesDrawerSubcategoryCubit(
            GetIt.instance<ArticlesDrawerSubcategoryRepoImpl>(),
          )..fetchArticles(
            categorySlug: widget.subcategory.slug ?? '',
            language: language,
          ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.subcategory.name ?? "No Name".tr()),
          elevation: 0,
        ),
        body: DrawerSubCategoryContentBlocBuider(
          widget: widget,
          language: language,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
