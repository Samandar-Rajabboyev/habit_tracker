import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/src/core/components/custom_appbar.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/features/habit/presentation/manager/habits/habits_cubit.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../../generated/l10n.dart';

class ReorderHabitsScreen extends StatelessWidget {
  const ReorderHabitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HabitsCubit>()..getHabits();
    return BlocBuilder<HabitsCubit, HabitsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.textLightColor,
          appBar: buildCustomAppBar(
            context,
            defaultLeading: true,
            title: Text(
              S.of(context).reorderHabits,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: context.textDarkColor,
              ),
            ),
          ),
          body: ReorderableColumn(
            onReorder: (int oldIndex, int newIndex) {
              cubit.reorderHabit(
                state.habits,
                state.habits[oldIndex].id ?? 0,
                newIndex + 1,
              );
            },
            children: List.generate(
              state.habits.length ?? 0,
              (index) {
                return Padding(
                  key: ValueKey(state.habits[index].id),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ClipPath(
                    clipper:
                        ShapeBorderClipper(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24))),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 29),
                      color: state.habits[index].color?.toColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.habits[index].name ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: context.textLightColor,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.line_horizontal_3,
                            size: 16,
                            color: context.textLightColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ).animate().moveY(
                begin: -80,
                end: 0,
                delay: const Duration(milliseconds: 250),
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastOutSlowIn,
              ),
        );
      },
    );
  }
}
