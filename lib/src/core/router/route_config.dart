import 'package:habit_tracker/src/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/features/habits/presentation/pages/habits_screen.dart';
import 'package:habit_tracker/src/features/settings/presentation/pages/reorder_habits_screen.dart';
import '../../features/habit/presentation/pages/create_habit_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator = GlobalKey(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: AppRoutes.habits.path,
  routes: [
    GoRoute(
      name: AppRoutes.habits.name,
      path: AppRoutes.habits.path,
      parentNavigatorKey: rootNavigator,
      pageBuilder: (context, state) => const HabitsScreen().defaultPage(state: state),
      routes: [
        GoRoute(
          name: AppRoutes.createHabit.name,
          path: AppRoutes.createHabit.path,
          parentNavigatorKey: rootNavigator,
          pageBuilder: (context, state) => const CreateHabitScreen().defaultPage(state: state),
        ),
        GoRoute(
          name: AppRoutes.editHabit.name,
          path: AppRoutes.editHabit.path,
          parentNavigatorKey: rootNavigator,
          pageBuilder: (context, state) => CreateHabitScreen(
            id: state.params['id'] == 'null' ? null : int.parse(state.params['id']!),
          ).defaultPage(state: state),
        ),
      ],
    ),
    GoRoute(
      name: AppRoutes.settings.name,
      path: AppRoutes.settings.path,
      parentNavigatorKey: rootNavigator,
      pageBuilder: (context, state) => const SettingsScreen().defaultPage(state: state),
      routes: [
        GoRoute(
          name: AppRoutes.reorderHabits.name,
          path: AppRoutes.reorderHabits.path,
          parentNavigatorKey: rootNavigator,
          pageBuilder: (context, state) => const ReorderHabitsScreen().defaultPage(state: state),
        ),
      ],
    ),
  ],
);
