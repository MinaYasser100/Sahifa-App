import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

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
                // Add your search results here
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text(
                        'Start typing to search...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const TextSearchBar({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorsTheme().primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: controller,
            hintText: 'Search...',
            ischangeColor: true,
            keyboardType: TextInputType.text,
            validator: (p0) {
              return null;
            },
          ),
        ),
      ),
    );
  }
}
