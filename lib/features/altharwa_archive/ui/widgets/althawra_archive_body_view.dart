import 'package:flutter/material.dart';

import 'arthawra_archive_bloc_builder_body.dart';

class AlthawraArchiveBodyView extends StatelessWidget {
  const AlthawraArchiveBodyView({
    super.key,
    required this.controller,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final TextEditingController controller;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AlthawraArchiveBlocBuilderBody(
            scrollController: _scrollController,
          ),
        ),
      ],
    );
  }
}
