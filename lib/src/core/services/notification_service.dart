import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:core/core.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initialize notification
  initializeNotification([bool test = false]) async {
    await _configureLocalTimeZone(test);
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Set right date and time for notifications
  Future<tz.TZDateTime> _convertTime(int weekday, int hour, int minutes) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    while (scheduleDate.weekday != weekday) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    LogService.d("$scheduleDate");
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone([bool test = false]) async {
    tz.initializeTimeZones();
    final String timeZone = test ? 'Asia/Tashkent' : await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Just Notification
  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Just notification',
      'Notification Body',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_tracker',
          'habit_tracker_channel',
          channelDescription: 'Habit Tracker',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Scheduled Notification
  scheduledNotification({
    required int weekday,
    required int hour,
    required int minutes,
    required String title,
    required String body,
    required int id,
  }) async {
    await flutterLocalNotificationsPlugin
        .zonedSchedule(
          id,
          title,
          body,
          // _getDayOfWeek(weekday) ?? Day.monday,
          // Time(hour, minutes),
          await _convertTime(weekday, hour, minutes),
          // tz.TZDateTime(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()), 2023, 6, 16, 8, 13),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'habit_tracker',
              'habit_tracker_channel',
              channelDescription: 'Habit Tracker',
              importance: Importance.max,
              priority: Priority.high,
              category: AndroidNotificationCategory.reminder,
              showWhen: true,
              playSound: true,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'It could be anything you pass',
        )
        .catchError((e) => LogService.e("$e"))
        .onError((error, stackTrace) => LogService.e("$error\n$stackTrace"));
  }

  /// Request IOS permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async =>
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  cancel(id) async => await flutterLocalNotificationsPlugin.cancel(id);
}
