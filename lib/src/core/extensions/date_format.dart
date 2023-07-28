import 'package:intl/intl.dart';

extension BasicDateStringFormatter on DateTime {
  String toDDMMYYY() {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  String toDDMMYYYHHmm() {
    return DateFormat('dd.MM.yyyy hh:mm').format(this);
  }

  String toHHmm() {
    return DateFormat('hh:mm').format(this);
  }
}

extension HHMMFormatOnDuration on Duration {
  String toHHMM() =>
      "${inHours >= 10 ? inHours : "0$inHours"}:${(inMinutes % 60) >= 10 ? (inMinutes % 60) : "0${(inMinutes % 60)}"}";
}

extension BasicStringDateFormatter on String {
  DateTime fromDDMMYYY() {
    return DateFormat('dd.MM.yyyy').parse(this);
  }

  DateTime fromDDMMYYYHHmm() {
    return DateFormat('dd.MM.yyyy hh:mm').parse(this);
  }

  DateTime hhmmToDateTime() {
    return DateFormat('hh:mm').parse(this);
  }

  Duration hhmmToDuration() {
    return Duration(hours: int.parse(split(':').first), minutes: int.parse(split(':').last));
  }
}
