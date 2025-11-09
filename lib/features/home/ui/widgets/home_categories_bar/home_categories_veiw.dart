import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/features/home/data/repo/articles_books_opinions_bar_category_repo.dart';
import 'package:sahifa/features/home/manger/articles_books_opinioins_bar_category_cubit/articles_books_opinions_bar_category_cubit.dart';
import 'package:sahifa/features/home/manger/articles_breaking_news_cubit/articles_breaking_news_cubit.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/books_opinions_articles_widget.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/breaking_news_articles_widget.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/other_categories_articles_widget.dart';

class HomeCategoriesView extends StatefulWidget {
  const HomeCategoriesView({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  State<HomeCategoriesView> createState() => _HomeCategoriesViewState();
}

class _HomeCategoriesViewState extends State<HomeCategoriesView> {
  final ScrollController _scrollController = ScrollController();
  late ArticlesBreakingNewsCubit? _breakingNewsCubit;
  late ArticlesBooksOpinionsBarCategoryCubit? _booksOpinionsCubit;

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
      _booksOpinionsCubit = null;
    }
    // Initialize Books & Opinions Cubit if needed
    else if (widget.categorySlug == 'books_opinions') {
      _booksOpinionsCubit = ArticlesBooksOpinionsBarCategoryCubit(
        ArticlesBooksOpinionsBarCategoryRepoImpl(),
      );
      _booksOpinionsCubit!.fetchArticles(language: context.locale.languageCode);
      _breakingNewsCubit = null;
    } else {
      _breakingNewsCubit = null;
      _booksOpinionsCubit = null;
    }

    // Fetch articles on first load
    _fetchArticles();
  }

  @override
  void didUpdateWidget(HomeCategoriesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch new articles when categorySlug changes
    if (oldWidget.categorySlug != widget.categorySlug) {
      log(
        'Category changed from ${oldWidget.categorySlug} to ${widget.categorySlug}',
      );

      // Close old cubits before creating new ones
      _breakingNewsCubit?.close();
      _booksOpinionsCubit?.close();

      // Re-initialize Breaking News Cubit if needed
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit = ArticlesBreakingNewsCubit(getIt());
        _breakingNewsCubit!.fetchBreakingNewsArticles(
          context.locale.languageCode,
        );
        _booksOpinionsCubit = null;
      }
      // Re-initialize Books & Opinions Cubit if needed
      else if (widget.categorySlug == 'books_opinions') {
        _booksOpinionsCubit = ArticlesBooksOpinionsBarCategoryCubit(
          getIt<ArticlesBooksOpinionsBarCategoryRepoImpl>(),
        );
        _booksOpinionsCubit!.fetchArticles(
          language: context.locale.languageCode,
        );
        _breakingNewsCubit = null;
      } else {
        _breakingNewsCubit = null;
        _booksOpinionsCubit = null;
      }

      _fetchArticles();
    }
  }

  void _fetchArticles() {
    // Skip fetch for Breaking News & Books/Opinions as they're handled by their own cubits
    if (widget.categorySlug == 'breaking-news' ||
        widget.categorySlug == 'books_opinions') {
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
    _booksOpinionsCubit?.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.categorySlug == 'breaking-news') {
        _breakingNewsCubit?.loadMore();
      } else if (widget.categorySlug == 'books_opinions') {
        _booksOpinionsCubit?.loadMoreArticles(
          language: context.locale.languageCode,
        );
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
        child: BreakingNewsArticlesWidget(
          scrollController: _scrollController,
          onRefresh: () async {
            await _breakingNewsCubit!.refresh();
          },
        ),
      );
    }

    // Handle Books & Opinions separately
    if (widget.categorySlug == 'books_opinions' &&
        _booksOpinionsCubit != null) {
      return BlocProvider.value(
        value: _booksOpinionsCubit!,
        child: BooksOpinionsArticlesWidget(
          scrollController: _scrollController,
          onRefresh: () async {
            await _booksOpinionsCubit!.refresh(
              language: context.locale.languageCode,
            );
          },
        ),
      );
    }

    // Handle other categories with existing cubit
    return OtherCategoriesArticlesWidget(
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
