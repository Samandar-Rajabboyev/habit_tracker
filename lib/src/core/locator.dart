import 'package:habit_tracker/src/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_tracker/src/core/services/notification_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../features/habit/data/models/habit.dart';
import '../features/habit/habit_di.dart';

final GetIt locator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Database
  // await AppDatabase.createDB();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [HabitSchema],
    name: 'app_data',
    directory: dir.path,
  );
  locator.registerSingleton<Isar>(isar);

  // Dio Client
  locator.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      contentType: "application/json; charset=UTF-8",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60 * 1000),
      receiveTimeout: const Duration(seconds: 60 * 1000),
      listFormat: ListFormat.multiCompatible,
    ),
  )
      // way of adding interceptors and ect.  ->   ..interceptors.addAll([]),
      );

  locator.registerSingleton(NotificationService()..initializeNotification());

  await habitDI();
}
