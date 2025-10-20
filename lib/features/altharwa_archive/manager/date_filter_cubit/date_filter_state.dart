part of 'date_filter_cubit.dart';

abstract class DateFilterState {}

class DateFilterInitial extends DateFilterState {}

class DateFilterApplied extends DateFilterState {
  final String fromDate;
  final String toDate;

  DateFilterApplied({required this.fromDate, required this.toDate});
}

class DateFilterCleared extends DateFilterState {}
