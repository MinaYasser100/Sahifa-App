import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/features/home/manger/articles_breaking_news_cubit/articles_breaking_news_cubit.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/manger/galeries_posts_cubit/galeries_posts_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/tablet_breaking_news_grid.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/tablet_galeries_grid.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/tablet_other_categories_grid.dart';

class HomeCategoriesTabletView extends StatefulWidget {
  const HomeCategoriesTabletView({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  State<HomeCategoriesTabletView> createState() =>
      _HomeCategoriesTabletViewState();
}

class _HomeCategoriesTabletViewState extends State<HomeCategoriesTabletView> {
  final ScrollController _scrollController = ScrollController();
  late ArticlesBreakingNewsCubit? _breakingNewsCubit;
  late GaleriesPostsCubit? _galeriesCubit;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('categorySlug: ${widget.categorySlug}');

    // Initialize Breaking News Cubit if needed
    if (widget.categorySlug == 'breaking-news') {
      _breakingNewsCubit = ArticlesBreakingNewsCubit(getIt());
      _breakingNewsCubit!.fetchBreakingNewsArticles(
        context.locale.languageCode,
      );
      _galeriesCubit = null;
    }
    // Initialize Galleries Cubit if needed
    else if (widget.categorySlug == 'galleries') {
      _galeriesCubit = GaleriesPostsCubit(getIt());
      _galeriesCubit!.fetchGaleriesPosts(context.locale.languageCode);
      _breakingNewsCubit = null;
    } else {
      _breakingNewsCubit = null;
      _galeriesCubit = null;
    }

    // Fetch articles on first load
    _fetchArticles();
  }

  @override
  void didUpdateWidget(HomeCategoriesTabletView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch new articles when categorySlug changes
    if (oldWidget.categorySlug != widget.categorySlug) {
      log(
        'Category changed from ${oldWidget.categorySlug} to ${widget.categorySlug}',
      );

      // Close old cubits before creating new ones
      _breakingNewsCubit?.close();
      _galeriesCubit?.close();

      // Re-initialize Breaking News Cubit if needed
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit = ArticlesBreakingNewsCubit(getIt());
        _breakingNewsCubit!.fetchBreakingNewsArticles(
          context.locale.languageCode,
        );
        _galeriesCubit = null;
      }
      // Re-initialize Galleries Cubit if needed
      else if (widget.categorySlug == 'galleries') {
        _galeriesCubit = GaleriesPostsCubit(getIt());
        _galeriesCubit!.fetchGaleriesPosts(context.locale.languageCode);
        _breakingNewsCubit = null;
      } else {
        _breakingNewsCubit = null;
        _galeriesCubit = null;
      }

      _fetchArticles();
    }
  }

  void _fetchArticles() {
    // Skip fetch for Breaking News and Galleries as they're handled by their own cubits
    if (widget.categorySlug == 'breaking-news' ||
        widget.categorySlug == 'galleries') {
      return;
    }

    final cubit = context.read<ArticlesHorizontalBarCategoryCubit>();
    cubit.fetchCategories(
      categorySlug: widget.categorySlug,
      language: context.locale.languageCode,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _breakingNewsCubit?.close();
    _galeriesCubit?.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit?.loadMore();
      } else if (widget.categorySlug == 'galleries') {
        _galeriesCubit?.loadMore();
      } else {
        context.read<ArticlesHorizontalBarCategoryCubit>().loadMoreArticles();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle Breaking News separately
    if (widget.categorySlug == 'breaking-news' && _breakingNewsCubit != null) {
      return BlocProvider.value(
        value: _breakingNewsCubit!,
        child: TabletBreakingNewsGrid(
          scrollController: _scrollController,
          onRefresh: () async {
            await _breakingNewsCubit!.refresh();
          },
        ),
      );
    }

    // Handle Galleries separately
    if (widget.categorySlug == 'galleries' && _galeriesCubit != null) {
      return BlocProvider.value(
        value: _galeriesCubit!,
        child: TabletGaleriesGrid(
          scrollController: _scrollController,
          onRefresh: () async {
            await _galeriesCubit!.refresh();
          },
        ),
      );
    }

    // Handle other categories with existing cubit
    return TabletOtherCategoriesGrid(
      categorySlug: widget.categorySlug,
      scrollController: _scrollController,
      onRefresh: () async {
        await context
            .read<ArticlesHorizontalBarCategoryCubit>()
            .refreshCategories();
      },
    );
  }
}
