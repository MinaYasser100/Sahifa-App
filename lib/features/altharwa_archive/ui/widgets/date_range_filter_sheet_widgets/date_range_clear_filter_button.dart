import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/altharwa_archive/manager/date_filter_cubit/date_filter_cubit.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

class DateRangeClearFilterButton extends StatelessWidget {
  const DateRangeClearFilterButton({
    super.key,
    required this.magazinesCubit,
    required this.dateFilterCubit,
  });

  final MagazinesCubit magazinesCubit;
  final DateFilterCubit dateFilterCubit;

  @override
  Widget build(BuildContext context) {
    if (!dateFilterCubit.isFiltered) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          dateFilterCubit.clearFilter();
          magazinesCubit.fetchMagazines();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ColorsTheme().primaryColor),
        ),
        child: Text(
          'clear_filter'.tr(),
          style: AppTextStyles.styleBold16sp(
            context,
          ).copyWith(color: ColorsTheme().primaryColor),
        ),
      ),
    );
  }
}
