import 'package:flutter/material.dart';

import 'widgets/categories_grid.dart';
import 'widgets/text_search_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _controller;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search here ...')),
      body: Column(
        children: [
          // Fixed Search Bar at the top
          TextSearchBar(controller: _controller),

          // Scrollable content below
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Categories Grid
                SliverToBoxAdapter(child: CategoriesGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
