import 'package:core/app_state/state_notifiers/locale_provider.dart';
import 'package:core/app_state/state_notifiers/theme_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../generated/l10n.dart';
import 'core/locator.dart';
import 'core/router/route_config.dart';
import 'core/theme/themes.dart';
import 'features/habit/presentation/manager/habits/habits_cubit.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(themeModeProvider, (previous, next) {
      LogService.d("$previous\n$next");
    });
    return BlocProvider(
      create: (context) => locator<HabitsCubit>(),
      child: Sizer(
        builder: (context, orientation, device) {
          return CoreApp(
            locale: ref.watch(localeProvider),
            appRouter: appRouter,
            themeMode: ref.watch(themeModeProvider),
            theme: lightTheme,
            darkTheme: darkTheme,
            localizationsDelegates: const [S.delegate],
          );
        },
      ),
    );
  }
}
