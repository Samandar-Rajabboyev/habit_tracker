import 'package:intl/intl.dart';

enum WeekDays {
  mon(WeekDayName(0), 1),
  tue(WeekDayName(1), 2),
  wed(WeekDayName(2), 3),
  thu(WeekDayName(3), 4),
  fri(WeekDayName(4), 5),
  sat(WeekDayName(5), 6),
  sun(WeekDayName(6), 7);

  final WeekDayName day;
  final int n;

  DateTime date() {
    DateTime now = DateTime.now();

    // whole weakDay's dates
    DateTime date = now.subtract(Duration(days: now.weekday - n));
    return date;
  }

  const WeekDays(this.day, this.n);
}

class WeekDayName {
  final int index;
  String get name => DateFormat().dateSymbols.WEEKDAYS[index];
  String get shortName => name.substring(0, 3);
  String get shortName2 => name.substring(0, 2);
  String get shortName3 => name.substring(0, 1);

  const WeekDayName(this.index);
}
