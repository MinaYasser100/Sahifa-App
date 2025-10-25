/// Utility functions for date formatting and conversion
class DateUtils {
  /// Convert DateTime to UTC String format
  /// Format: 2025-10-20T10:00:36.1794008 (ISO 8601 without Z)
  static String convertToUtcString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    // Use current time for precision
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    // Combine millisecond (3 digits) + microsecond (4 digits) = 7 digits total
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    final microsecond = now.microsecond.toString().padLeft(4, '0');
    final fractionalSeconds = '$millisecond$microsecond';

    // Combine to create: 2025-10-20T10:00:36.1794008
    return '$year-$month-${day}T$hour:$minute:$second.$fractionalSeconds';
  }

  /// Convert DateTime to DD/MM/YYYY format
  static String convertToDDMMYYYY(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
