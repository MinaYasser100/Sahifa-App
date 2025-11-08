import 'package:timeago/timeago.dart' as timeago;

/// Initialize timeago with Arabic locale
void initTimeago() {
  timeago.setLocaleMessages('ar', ArMessages());
}

/// Arabic messages for timeago
class ArMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'بعد';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'الآن';
  @override
  String aboutAMinute(int minutes) => 'دقيقة واحدة';
  @override
  String minutes(int minutes) => '$minutes دقائق';
  @override
  String aboutAnHour(int minutes) => 'ساعة واحدة';
  @override
  String hours(int hours) => '$hours ساعات';
  @override
  String aDay(int hours) => 'يوم واحد';
  @override
  String days(int days) => '$days أيام';
  @override
  String aboutAMonth(int days) => 'شهر واحد';
  @override
  String months(int months) => '$months أشهر';
  @override
  String aboutAYear(int year) => 'سنة واحدة';
  @override
  String years(int years) => '$years سنوات';
  @override
  String wordSeparator() => ' ';
}

class EnglishMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'in';
  @override
  String suffixAgo() => 'ago';
  @override
  String suffixFromNow() => 'from now';
  @override
  String lessThanOneMinute(int seconds) => 'less than a minute';
  @override
  String aboutAMinute(int minutes) => 'about a minute';
  @override
  String minutes(int minutes) => '$minutes minutes';
  @override
  String aboutAnHour(int minutes) => 'about an hour';
  @override
  String hours(int hours) => '$hours hours';
  @override
  String aDay(int hours) => 'a day';
  @override
  String days(int days) => '$days days';
  @override
  String aboutAMonth(int days) => 'about a month';
  @override
  String months(int months) => '$months months';
  @override
  String aboutAYear(int year) => 'about a year';
  @override
  String years(int years) => '$years years';
  @override
  String wordSeparator() => ' ';
}
