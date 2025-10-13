import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

class DetailsArticleContent extends StatelessWidget {
  const DetailsArticleContent({super.key, required this.articalModel});

  final ArticalItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            articalModel.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsTheme().primaryLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Metadata Row
          Row(
            children: [
              // Date
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: ColorsTheme().primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatDate(articalModel.date),
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorsTheme().primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 24),

          // Divider
          Divider(color: ColorsTheme().dividerColor, thickness: 1),
          const SizedBox(height: 24),

          // Description
          Text(
            articalModel.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 24),

          // Full Article Content (dummy text for now)
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
            'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.\n\n'
            'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.8,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
