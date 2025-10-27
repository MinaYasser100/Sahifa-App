import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/features/search/ui/data/repo/search_articles_repo.dart';
import 'package:sahifa/features/search/ui/manager/search_articles_cubit/search_articles_cubit.dart';

import 'widgets/categories_grid.dart';
import 'widgets/search_results_widget.dart';
import 'widgets/text_search_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchArticlesCubit(getIt<SearchArticlesRepoImpl>()),
      child: const _SearchViewBody(),
    );
  }
}

class _SearchViewBody extends StatefulWidget {
  const _SearchViewBody();

  @override
  State<_SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<_SearchViewBody> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final language = context.locale.languageCode;

    if (query.trim().isEmpty) {
      // If query is empty, show grid
      setState(() {
        _isSearching = false;
      });
    } else {
      // If query has text, search and show results
      setState(() {
        _isSearching = true;
      });
      context.read<SearchArticlesCubit>().searchArticlesByQuery(
        query,
        language,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search_here'.tr())),
      body: Column(
        children: [
          // Fixed Search Bar at the top
          TextSearchBar(controller: _controller, onChanged: _onSearchChanged),

          // Scrollable content below
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Show grid when not searching, results when searching
                if (_isSearching)
                  const SearchResultsWidget()
                else
                  const SliverToBoxAdapter(child: CategoriesGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
