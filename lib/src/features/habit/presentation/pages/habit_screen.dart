import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/src/core/components/custom_alert_dialog.dart';
import 'package:habit_tracker/src/core/constants/app_enums.dart' as my;
import 'package:habit_tracker/src/core/extensions/date_format.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/core/extensions/image_path.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/router/app_routes.dart';
import 'package:habit_tracker/src/features/habit/data/models/habit.dart';
import 'package:habit_tracker/src/features/habit/presentation/manager/habits/habits_cubit.dart';
import 'package:habit_tracker/src/features/habit/presentation/pages/share_habit_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/theme/colors.dart';
import '../../../habits/presentation/widgets/habit_card.dart';

showHabitBottomSheet(BuildContext context, int id, Color color) {
  showMaterialModalBottomSheet(
    context: context,
    backgroundColor: color,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return HabitBottomSheet(id: id);
    },
  );
}

class HabitBottomSheet extends StatefulWidget {
  final int id;
  const HabitBottomSheet({Key? key, required this.id}) : super(key: key);

  @override
  State<HabitBottomSheet> createState() => _HabitBottomSheetState();
}

class _HabitBottomSheetState extends State<HabitBottomSheet> {
  CalendarController calendarController = CalendarController();
  String calendarMonth = DateFormat('MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Habit?>(
      stream: context.read<HabitsCubit>().habit(widget.id),
      builder: (context, snapshot) {
        String name = snapshot.data?.name ?? '';
        String description = snapshot.data?.description ?? '';
        Color color = (snapshot.data?.color?.toColor) ?? Clrs.baseColor2;
        List<String> completedDates = snapshot.data?.completedDates ?? [];
        bool isTodayCompleted = completedDates.contains(DateTime.now().toDDMMYYY());
        String reminderHour = snapshot.data?.reminderHour ?? '12:00';
        List<ReminderDay> reminderDays = snapshot.data?.reminderDays ?? [];
        bool hasReminder = snapshot.data?.hasReminder ?? false;

        return Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomButton(
                                press: () => context
                                    .read<HabitsCubit>()
                                    .completeHabit(snapshot.data!, DateTime.now().toDDMMYYY()),
                                width: 45,
                                height: 45,
                                borderRadius: BorderRadius.circular(90),
                                color: isTodayCompleted ? color.lighten() : null,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color: isTodayCompleted ? context.textLightColor : context.textDarkColor,
                                  ),
                                ),
                              ),
                              16.pw,
                              Builder(builder: (context) {
                                int constancy = calculateConstancyNumber(completedDates).round();
                                int consecutive = calculateConsecutiveNumber(completedDates);
                                return constancy == 0
                                    ? const SizedBox.shrink()
                                    : CustomButton(
                                        padding: const EdgeInsets.all(6),
                                        color: color.lighten(),
                                        disable: true,
                                        press: () {},
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.icFlame,
                                              color: context.textLightColor,
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(
                                              ' $consecutive ',
                                              style: TextStyle(
                                                color: context.textLightColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }),
                            ],
                          ),
                          CustomButton(
                            press: () {
                              context.popX();
                              context.goNamed(
                                AppRoutes.editHabit.name,
                                queryParameters: {'id': '${snapshot.data?.id}'},
                              );
                            },
                            width: 45,
                            height: 45,
                            borderRadius: BorderRadius.circular(90),
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                AppAssets.icEdit,
                                color: context.iconDarkColor,
                              ),
                            ),
                          ).animate().fade(
                                delay: const Duration(milliseconds: 100),
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.easeOutCubic,
                              ),
                        ],
                      ),
                      16.ph,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: context.textLightColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 26,
                                  ),
                                ),
                                8.ph,
                                Text(
                                  description,
                                  style: TextStyle(
                                    color: context.textLightColor.withOpacity(.8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              CustomButton(
                                press: () {
                                  if (snapshot.data?.id != null) {
                                    showShareHabitBottomSheet(context, (snapshot.data?.id)!);
                                  }
                                },
                                width: 45,
                                height: 45,
                                borderRadius: BorderRadius.circular(90),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppAssets.icShare,
                                    color: context.iconDarkColor,
                                  ),
                                ),
                              ).animate().fade(
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeOutCubic,
                                  ),
                              16.ph,
                              CustomButton(
                                press: snapshot.data == null
                                    ? () {}
                                    : () async {
                                        await showActDialog(
                                          context,
                                          S.of(context).deleteHabit,
                                          S.of(context).actForDeletion(name),
                                        ).then((value) {
                                          if (value ?? false) {
                                            context.read<HabitsCubit>().deleteHabit((snapshot.data?.id)!, reminderDays);
                                            context.popX();
                                          }
                                        });
                                      },
                                width: 45,
                                height: 45,
                                borderRadius: BorderRadius.circular(90),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppAssets.icTrash,
                                    color: context.iconDarkColor,
                                  ),
                                ),
                              ).animate().fade(
                                    delay: const Duration(milliseconds: 300),
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.easeOutCubic,
                                  ),
                            ],
                          ),
                        ],
                      ),
                      if (hasReminder) 8.ph,
                      if (hasReminder)
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.lighten(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).reminder,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: context.textLightColor,
                                      ),
                                    ),
                                    CustomButton(
                                      press: () {},
                                      color: color,
                                      disable: true,
                                      child: Text(
                                        reminderHour,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: context.textLightColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                8.ph,
                                Text(
                                  my.WeekDays.values
                                      .map((e) {
                                        if (reminderDays.any((item) => item.weekDay == e.n)) {
                                          return e.day.shortName2;
                                        }
                                      })
                                      .toList()
                                      .where((element) => element != null)
                                      .join(', '),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: context.textLightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: context.textLightColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              press: () => (calendarController.backward != null) ? calendarController.backward!() : '',
                              width: 45,
                              height: 45,
                              borderRadius: BorderRadius.circular(90),
                              color: context.isDark ? Clrs.textBlack.lighten() : Clrs.textWhite10.lighten(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.arrow_left,
                                  size: 22,
                                  color: context.iconDarkColor,
                                ),
                              ),
                            ),
                            Text(
                              calendarMonth,
                              style: TextStyle(
                                color: context.textDarkColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Text(DateFormat('EE yyyy').format(()),
                            CustomButton(
                              press: () => (calendarController.forward != null) ? calendarController.forward!() : '',
                              width: 45,
                              height: 45,
                              borderRadius: BorderRadius.circular(90),
                              color: context.isDark ? Clrs.textBlack.lighten() : Clrs.textWhite10.lighten(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.arrow_right,
                                  size: 22,
                                  color: context.iconDarkColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      8.ph,
                      Builder(builder: (context) {
                        DateTime startDate = DateTime(200);
                        DateTime endDate = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        );
                        return SfCalendar(
                          onTap: (details) => (snapshot.data != null && details.date != null)
                              ? context.read<HabitsCubit>().completeHabit(snapshot.data!, details.date!.toDDMMYYY())
                              : '',
                          onViewChanged: (details) {
                            SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
                              setState(() {
                                calendarMonth = DateFormat('MMM yyyy')
                                    .format(details.visibleDates[details.visibleDates.length ~/ 2]);
                              });
                            });
                          },
                          controller: calendarController,
                          view: CalendarView.month,
                          // cellBorderColor: Colors.transparent,
                          todayHighlightColor: Colors.transparent,
                          showCurrentTimeIndicator: false,
                          monthViewSettings: const MonthViewSettings(
                            numberOfWeeksInView: 6,
                            showTrailingAndLeadingDates: true,
                          ),
                          maxDate: endDate,
                          minDate: startDate,
                          firstDayOfWeek: 1,
                          headerHeight: 0,
                          headerStyle: const CalendarHeaderStyle(textAlign: TextAlign.center),
                          selectionDecoration: const BoxDecoration(),
                          monthCellBuilder: (context, details) {
                            bool completed = completedDates.contains(details.date.toDDMMYYY());

                            return FittedBox(
                              child: Column(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: completed ? color : null,
                                    ),
                                    child: Text(
                                      details.date.day.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: completed
                                            ? context.textLightColor
                                            : (details.date.difference(endDate).inDays.isNegative
                                                ? context.textDarkColor
                                                : context.textDarkColor.withOpacity(.5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
