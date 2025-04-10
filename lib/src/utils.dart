import 'package:intl/intl.dart';

/// Returns the default week days as strings (using intl).
/// 
/// * [locale] - Optional locale to use for formatting. If not provided, the current locale will be used.
List<String> defaultWeekDays({required String locale}) =>
    DateFormat.E(locale).dateSymbols.WEEKDAYS.map((e) => e.substring(0, 3)).toList();
