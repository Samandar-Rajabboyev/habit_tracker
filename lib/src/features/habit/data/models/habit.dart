import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id? id = Isar.autoIncrement;

  int? order = Isar.autoIncrement;

  String? name;

  String? description;

  String? color;

  List<String>? completedDates;

  bool? hasReminder;

  String? reminderHour;

  List<ReminderDay>? reminderDays;
}

@embedded
class ReminderDay {
  int? weekDay;
  int? notificationId;
}
