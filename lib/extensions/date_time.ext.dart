import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get formattedDateTime {
    return DateFormat.yMMMEd().format(this);
  }
}
