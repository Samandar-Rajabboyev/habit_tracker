import "package:habit_tracker/src/features/habit/presentation/manager/habits/habits_cubit.dart";
import "package:isar/isar.dart";

import "../../core/locator.dart";

Future<void> habitDI() async {
  // DataSources
  // locator.registerSingleton(HabitApiService(locator()));

  // Repositories
  // locator.registerSingleton<HabitRepository>(HabitRepositoryImpl(locator()));

  // UseCases
  // locator.registerSingleton(CustomUseCase(locator()));

  // Blocs
  locator.registerFactory<HabitsCubit>(() => HabitsCubit(locator<Isar>()));
}
