import 'package:bloc/bloc.dart';
import 'package:habit_tracker/src/core/services/notification_service.dart';
import 'package:isar/isar.dart';

import '../../../../../core/locator.dart';
import '../../../data/models/habit.dart';

part 'habits_state.dart';

class HabitsCubit extends Cubit<HabitsState> {
  final Isar isar;

  HabitsCubit(this.isar) : super(HabitsState());

  Stream<List<Habit>> get habits =>
      isar.habits.filter().colorIsNotEmpty().sortByOrder().build().watch(fireImmediately: true);

  Future<Habit?> getHabit(int id) async => await isar.habits.get(id);

  Stream<Habit?> habit(int id) => isar.habits.watchObject(id, fireImmediately: true);

  completeHabit(Habit habit, String date) async {
    await isar.writeTxn(() async {
      if (habit.completedDates?.contains(date) ?? false) {
        habit.completedDates = habit.completedDates?.where((element) => element != date).toList();
      } else {
        habit.completedDates = [...?habit.completedDates, date];
      }
      isar.habits.put(habit);
    });
  }

  getHabits() async {
    await isar.habits
        .filter()
        .colorIsNotEmpty()
        .sortByOrder()
        .build()
        .findAll()
        .then((value) => emit(state.copyWith(habits: value)));
  }

  Future<void> reorderHabit(List<Habit> habits, int id, int order) async {
    await isar.writeTxn(() async {
      List<Habit> newData = habits;

      Habit i = habits.firstWhere((element) => element.id == id);

      habits.removeWhere((element) => element.id == i.id);

      if ((i.order ?? 0) < order) {
        for (var e in newData) {
          if ((e.order ?? 0) > (i.order ?? 0) && (e.order ?? 0) <= order) {
            e.order = (e.order ?? 0) - 1;
          }
        }
      } else {
        for (var e in newData) {
          if ((e.order ?? 0) >= order) {
            e.order = (e.order ?? 0) + 1;
          }
        }
      }

      i.order = order;
      newData.add(i);
      newData.sort((a, b) => a.order?.compareTo(b.order ?? 0) ?? 0);
      for (var element in newData) {
        element.order = newData.indexWhere((el) => el.id == element.id) + 1;
      }

      emit(state.copyWith(habits: newData));

      await isar.habits.putAll(newData);
    });
  }

  Future<void> createHabit(Habit habit) async {
    await isar.writeTxn(() async {
      if (habit.order == null) {
        await isar.habits.filter().colorIsNotEmpty().sortByOrder().findAll().then((value) {
          if (value.isNotEmpty) {
            habit.order = (value.last.order ?? 0) + 1;
          } else {
            habit.order = 1;
          }
        });
      }

      await isar.habits.put(habit).then((value) async {
        if (habit.hasReminder ?? false) {
          habit.reminderDays?.forEach((element) {
            locator<NotificationService>().scheduledNotification(
              title: habit.name ?? 'title',
              body: "It's time to add a completion to ${habit.name}",
              weekday: element.weekDay!,
              hour: int.parse((habit.reminderHour?.split(':').first ?? '8')),
              minutes: int.parse((habit.reminderHour?.split(':').last ?? '0')),
              id: element.notificationId!,
            );
          });
        }
      });
    });
  }

  Future<void> deleteHabit(int id, List<ReminderDay> reminderDays) async {
    await isar.writeTxn(() async {
      for (var element in reminderDays) {
        locator<NotificationService>().cancel(element.notificationId);
      }
      await isar.habits.delete(id);
    });
  }
}
