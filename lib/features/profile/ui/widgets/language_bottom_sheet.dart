import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/constant.dart';

import 'language_option.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorsTheme().primaryLight : ColorsTheme().whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          FadeInDown(
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language'.tr(),
                    style: AppTextStyles.styleBold18sp(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? ColorsTheme().whiteColor
                          : ColorsTheme().blackColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // English Option
          FadeInLeft(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 400),
            child: LanguageOption(
              languageName: 'English',
              languageCode: 'EN',
              locale: const Locale(ConstantVariable.englishLangCode),
              isSelected:
                  currentLocale.languageCode ==
                  ConstantVariable.englishLangCode,
              onTap: () async {
                await context.setLocale(
                  const Locale(ConstantVariable.englishLangCode),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),

          // Arabic Option
          FadeInRight(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 400),
            child: LanguageOption(
              languageName: 'العربية',
              languageCode: 'AR',
              locale: const Locale(ConstantVariable.arabicLangCode),
              isSelected:
                  currentLocale.languageCode == ConstantVariable.arabicLangCode,
              onTap: () async {
                await context.setLocale(
                  const Locale(ConstantVariable.arabicLangCode),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
