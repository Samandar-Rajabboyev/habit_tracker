import 'package:blur/blur.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/src/core/components/custom_appbar.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/router/app_routes.dart';
import 'package:habit_tracker/src/core/theme/colors.dart';
import 'package:habit_tracker/src/features/habit/data/models/habit.dart';
import 'package:habit_tracker/src/features/habit/presentation/manager/habits/habits_cubit.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/components/custom_button.dart';
import '../widgets/habit_card.dart';

final viewModeProvider = StateProvider<int>((ref) => 0);

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HabitsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HabitsScreen> {
  late HabitsCubit _habitsCubit;

  @override
  void initState() {
    super.initState();
    _habitsCubit = context.read<HabitsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(viewModeProvider);
    return StreamBuilder<List<Habit>>(
      stream: _habitsCubit.habits,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: context.textLightColor,
          appBar: buildCustomAppBar(
            context,
            leading: IconButton(
              onPressed: () => context.pushNamed(AppRoutes.settings.name),
              icon: Icon(Icons.settings_rounded, color: context.iconDarkColor),
            ),
            title: Row(
              children: [
                Visibility(
                  visible:
                      !((S.of(context).langCode == Localization.uz.languageCode && (snapshot.data?.isEmpty ?? true)) ||
                          (S.of(context).langCode == Localization.ru.languageCode && viewMode == 0)),
                  child: Flexible(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.topCenter,
                      child: Text(
                        snapshot.data?.isEmpty ?? true
                            ? S.of(context).no
                            : viewMode == 0
                                ? S.of(context).todays
                                : viewMode == 1
                                    ? S.of(context).weekly
                                    : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: context.textDarkColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    " ${S.of(context).habits} ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Clrs.baseColor2,
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      (S.of(context).langCode == Localization.uz.languageCode && (snapshot.data?.isEmpty ?? true)) ||
                          (S.of(context).langCode == Localization.ru.languageCode && viewMode == 0),
                  child: Flexible(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.topCenter,
                      child: Text(
                        snapshot.data?.isEmpty ?? true
                            ? S.of(context).no
                            : viewMode == 0
                                ? S.of(context).todays
                                : viewMode == 1
                                    ? S.of(context).weekly
                                    : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: context.textDarkColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => context.goNamed(AppRoutes.createHabit.name),
                icon: Icon(Icons.add_circle_rounded, color: context.iconDarkColor),
              ),
              8.pw,
            ],
          ),
          extendBodyBehindAppBar: true,
          body: (snapshot.data?.isEmpty ?? true)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).noHabitsFound,
                        style: TextStyle(
                          color: context.textDarkColor.darken(40),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      16.ph,
                      CustomButton(
                        color: context.isDark ? context.textLightColor.lighten() : context.textLightColor.darken(),
                        child: Text(
                          S.of(context).createHabit,
                          style: TextStyle(
                            fontSize: 18,
                            color: context.textDarkColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        press: () => context.pushNamed(AppRoutes.createHabit.name),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 80),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return HabitCard(
                            habit: snapshot.data?[index],
                            viewMode: viewMode,
                            onComplete: (date) => snapshot.data?[index] == null
                                ? ''
                                : _habitsCubit.completeHabit((snapshot.data?[index])!, date),
                          );
                        },
                      ).animate().moveY(
                            begin: -80,
                            end: 0,
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                          ),
                    ),
                    buildBottomNavigator(context, viewMode, snapshot.data?.isEmpty ?? true),
                  ],
                ),
        );
      },
    );
  }

  AnimatedPositioned buildBottomNavigator(BuildContext context, int viewMode, bool noData) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 900),
      bottom: noData ? -7.h : 3.8.h,
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(
                    color: context.isDark ? Colors.white12 : Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 29,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Blur(
                      blur: 20,
                      blurColor: context.textLightColor,
                      borderRadius: BorderRadius.circular(90),
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 700),
                      alignment: viewMode == 0
                          ? Alignment.centerLeft
                          : (viewMode == 1 ? Alignment.center : Alignment.centerRight),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Clrs.baseColor2.withOpacity(.3),
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(viewModeProvider.notifier).state = 0;
                          },
                          icon: Icon(
                            Icons.view_stream_rounded,
                            color: context.iconDarkColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(viewModeProvider.notifier).state = 1;
                          },
                          icon: Icon(
                            Icons.view_agenda_rounded,
                            color: context.iconDarkColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(viewModeProvider.notifier).state = 2;
                          },
                          icon: Icon(
                            Icons.calendar_view_month_rounded,
                            color: context.iconDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().moveY(
                  begin: 250,
                  end: 0,
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    );
  }
}
