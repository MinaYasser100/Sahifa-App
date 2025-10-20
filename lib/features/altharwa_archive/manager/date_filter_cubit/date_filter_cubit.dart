import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'date_filter_state.dart';

class DateFilterCubit extends Cubit<DateFilterState> {
  DateFilterCubit() : super(DateFilterInitial());

  String? _fromDate;
  String? _toDate;

  String? get fromDate => _fromDate;
  String? get toDate => _toDate;
  bool get isFiltered => _fromDate != null && _toDate != null;

  /// Validate and set date range
  /// Returns error message if validation fails, null if success
  String? setDateRange({required String fromDate, required String toDate}) {
    // Parse dates (format: DD/MM/YYYY)
    final fromParts = fromDate.split('/');
    final toParts = toDate.split('/');

    if (fromParts.length != 3 || toParts.length != 3) {
      return 'invalid_date_format';
    }

    try {
      final from = DateTime(
        int.parse(fromParts[2]), // year
        int.parse(fromParts[1]), // month
        int.parse(fromParts[0]), // day
      );

      final to = DateTime(
        int.parse(toParts[2]), // year
        int.parse(toParts[1]), // month
        int.parse(toParts[0]), // day
      );

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Validation 1: fromDate should not be after today
      if (from.isAfter(today)) {
        return 'from_date_cannot_be_future'.tr();
      }

      // Validation 2: toDate should not be after today
      if (to.isAfter(today)) {
        return 'to_date_cannot_be_future'.tr();
      }

      // Validation 3: fromDate should be before or equal toDate
      if (from.isAfter(to)) {
        return 'from_date_must_be_before_to_date'.tr();
      }

      // All validations passed
      _fromDate = fromDate;
      _toDate = toDate;
      emit(DateFilterApplied(fromDate: fromDate, toDate: toDate));
      return null;
    } catch (e) {
      return 'invalid_date_format'.tr();
    }
  }

  /// Clear the filter
  void clearFilter() {
    _fromDate = null;
    _toDate = null;
    emit(DateFilterCleared());
  }
}
