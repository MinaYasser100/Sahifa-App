import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/profile/data/model/contact_info_model.dart';

class ContactInfoCard extends StatelessWidget {
  final ContactInfoModel model;

  const ContactInfoCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Card(
      color: model.isDark ? colors.primaryColor : colors.whiteColor,
      elevation: 2,
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: model.isDark
                      ? colors.primaryColor.withValues(alpha: 0.3)
                      : colors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  model.icon,
                  color: model.isDark
                      ? colors.secondaryColor
                      : colors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: model.isDark
                            ? colors.softBlue
                            : colors.grayColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: model.isDark
                            ? colors.whiteColor
                            : colors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: model.onCopy,
                child: Icon(
                  Icons.copy,
                  size: 20,
                  color: model.isDark ? colors.softBlue : colors.grayColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
