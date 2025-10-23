part of 'date_filter_cubit.dart';

// Simple state - only used for initialization
// We use getters (fromDate, toDate, isFiltered) instead of emitting states
abstract class DateFilterState {}

class DateFilterInitial extends DateFilterState {}
