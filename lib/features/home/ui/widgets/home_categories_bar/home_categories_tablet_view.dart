import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/features/home/manger/articles_breaking_news_cubit/articles_breaking_news_cubit.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/tablet_breaking_news_grid.dart';
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
    } else {
      _breakingNewsCubit = null;
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

      // Close old cubit before creating new one
      _breakingNewsCubit?.close();

      // Re-initialize Breaking News Cubit if needed
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit = ArticlesBreakingNewsCubit(getIt());
        _breakingNewsCubit!.fetchBreakingNewsArticles(
          context.locale.languageCode,
        );
      } else {
        _breakingNewsCubit = null;
      }

      _fetchArticles();
    }
  }

  void _fetchArticles() {
    // Skip fetch for Breaking News as it's handled by its own cubit
    if (widget.categorySlug == 'breaking-news') {
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
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit?.loadMore();
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
