import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/core/components/custom_button.dart';
import 'package:habit_tracker/src/core/extensions/date_format.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../habit/data/models/habit.dart';
import '../../../habit/presentation/pages/habit_screen.dart';

class HabitCard extends StatelessWidget {
  final Habit? habit;
  final int viewMode;
  final Function(String date) onComplete;
  final BorderRadius? borderRadius;
  final bool showIndicator;
  const HabitCard({
    super.key,
    this.borderRadius,
    required this.habit,
    required this.viewMode,
    required this.onComplete,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    String nowFormatted = DateTime.now().toDDMMYYY();
    String title = habit?.name ?? '';
    String description = habit?.description ?? '';
    Color? clr = habit?.color?.toColor;
    bool isTodayCompleted = habit?.completedDates?.contains(nowFormatted) ?? false;

    DateTime? _startDate;
    DateTime? _endDate;

    if ((habit?.completedDates ?? []).isNotEmpty) {
      List<DateTime> completedDates = habit?.completedDates?.map<DateTime>((e) => e.fromDDMMYYY()).toList() ?? [];
      completedDates.sort((a, b) => b.compareTo(a));
      _startDate = completedDates.last;
      _endDate = DateTime.now();
    }

    return GestureDetector(
      onTap: () {
        showHabitBottomSheet(context, (habit?.id)!, clr!);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: clr?.withOpacity(.5),
          borderRadius: borderRadius ?? BorderRadius.circular(viewMode == 0 ? 18 : (viewMode == 1 ? 16 : 12)),
        ),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: AnimatedSize(
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: viewMode == 0
                    ? CrossAxisAlignment.center
                    : (description.isEmpty ? CrossAxisAlignment.center : CrossAxisAlignment.start),
                children: [
                  Expanded(
                    child: AnimatedAlign(
                      curve: Curves.easeInOutCubic,
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: viewMode == 0 ? TextAlign.left : null,
                              style: TextStyle(
                                fontSize: description.isEmpty ? 24 : 18,
                                fontWeight: FontWeight.w400,
                                color: context.iconDarkColor,
                              ),
                            ),
                          if (description.isNotEmpty) 5.ph,
                          if (description.isNotEmpty)
                            Text(
                              description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: context.iconDarkColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  8.pw,
                  Visibility(
                    visible: showIndicator,
                    child: viewMode == 0
                        ? GestureDetector(
                            onTap: () => onComplete(nowFormatted),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: isTodayCompleted ? clr : null,
                                border: Border.all(
                                  color: (clr?.withOpacity(.6))!,
                                  width: 2,
                                ),
                              ),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isTodayCompleted ? 1 : 0,
                                child: const Icon(CupertinoIcons.checkmark_alt, color: Colors.white),
                              ),
                            ),
                          )
                        : CustomButton(
                            color: isTodayCompleted ? clr : context.textLightColor,
                            child: viewMode != 2
                                ? Text(
                                    S.of(context).complete.toLowerCase(),
                                    style: TextStyle(
                                      color: isTodayCompleted ? context.textLightColor : context.textDarkColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Icon(
                                    CupertinoIcons.checkmark,
                                    color: isTodayCompleted ? context.textLightColor : context.textDarkColor,
                                  ),
                            press: () => onComplete(nowFormatted),
                          ),
                  ),
                ],
              ),
              if (viewMode != 0) 10.ph,
              AnimatedSize(
                // switchInCurve: Curves.easeOutCubic,
                // switchOutCurve: Curves.easeOutCubic,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 500),
                child: (viewMode == 0)
                    ? const SizedBox.shrink()
                    : (viewMode == 1
                        ? Row(
                            children: List.generate(
                              WeekDays.values.length,
                              (index) {
                                WeekDays weakDay = WeekDays.values[index];
                                DateTime currentItemDate = weakDay.date();

                                DateTime now = DateTime.now();

                                // whole weakDay's dates
                                bool isToday = now.weekday == (index + 1);
                                bool disabled = now.weekday < (index + 1);

                                // if habit's checkeds list contains this date
                                bool isChecked = habit?.completedDates?.contains(currentItemDate.toDDMMYYY()) ?? false;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: disabled ? () {} : () => onComplete(currentItemDate.toDDMMYYY()),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.all(7),
                                      decoration: !isToday
                                          ? null
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: clr?.withOpacity(.2),
                                            ),
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            8.ph,
                                            Text(
                                              weakDay.day.shortName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: disabled
                                                    ? context.textDarkColor.withOpacity(.3)
                                                    : context.textDarkColor,
                                              ),
                                            ),
                                            6.ph,
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(90),
                                                color: isChecked ? clr : null,
                                                border: Border.all(
                                                  color: (disabled ? clr?.withOpacity(.3) : clr?.withOpacity(.6))!,
                                                  width: 2,
                                                ),
                                              ),
                                              child: AnimatedOpacity(
                                                duration: const Duration(milliseconds: 200),
                                                opacity: isChecked ? 1 : 0,
                                                child: const Icon(CupertinoIcons.checkmark_alt, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Builder(
                            builder: (context) {
                              DateTime startDate = DateTime(
                                DateTime.now().year - 1,
                                DateTime.now().month,
                                DateTime.now().day,
                              );
                              DateTime endDate = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 1,
                              );
                              List<DateTime> completedDates =
                                  habit?.completedDates?.map<DateTime>((e) => e.fromDDMMYYY()).toList() ?? [];
                              completedDates.sort((a, b) => b.compareTo(a));
                              if (completedDates.isNotEmpty) {
                                if (completedDates.last.difference(startDate).inDays.isNegative) {
                                  startDate = completedDates.last;
                                }
                              }
                              int count = endDate.difference(startDate).inDays;
                              List<Map<int, String>> listOfDates = List.generate(
                                count,
                                (index) {
                                  endDate = DateTime(endDate.year, endDate.month, endDate.day - 1);
                                  return {index: endDate.toDDMMYYY()};
                                },
                              );
                              List<String> tempDates = habit?.completedDates ?? [];
                              return SizedBox(
                                height: 10.h,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  itemCount: listOfDates.length,
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    bool inPeriod = false;
                                    if (_startDate != null && _endDate != null) {
                                      if (_startDate.difference(listOfDates[index].values.first.fromDDMMYYY()).inDays <=
                                              0 &&
                                          listOfDates[index].values.first.fromDDMMYYY().difference(_endDate).inDays <=
                                              0) {
                                        inPeriod = true;
                                      }
                                    }

                                    return Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: tempDates.contains(listOfDates[index].values.first)
                                            ? clr
                                            : inPeriod
                                                ? clr?.withOpacity(.5)
                                                : clr?.withOpacity(.3),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double calculateConstancyNumber(List<String> dates) {
  if (dates.isEmpty) {
    return 0;
  }
  List<DateTime> completedDates = dates.map<DateTime>((e) => e.fromDDMMYYY()).toList();
  completedDates.sort((a, b) => b.compareTo(a));

  // Define the start and end dates for calculating the constancy number
  DateTime startDate = completedDates.last;
  DateTime endDate = completedDates.first;

  // Calculate the number of days between the start and end dates
  int totalDays = endDate.difference(startDate).inDays + 1;

  // Calculate the number of completed days during this period
  int completedDays = 0;
  for (DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))) {
    if (completedDates.contains(date)) {
      completedDays++;
    }
  }

  // Calculate the constancy number as a percentage
  double constancyNumber = (completedDays / totalDays) * 100;

  return constancyNumber;
}

int calculateConsecutiveNumber(List<String> dates) {
  // Define the list of completed dates for the habit
  if (dates.isEmpty) {
    return 0;
  }
  List<DateTime> completedDates = dates.map<DateTime>((e) => e.fromDDMMYYY()).toList();
  completedDates.sort((a, b) => a.compareTo(b));

  // Initialize variables for tracking the consecutive days and the longest streak
  int consecutiveDays = 1;
  int longestStreak = 1;

  // Loop through the completed dates and calculate the consecutive days and longest streak
  for (int i = 1; i < completedDates.length; i++) {
    if (completedDates[i].difference(completedDates[i - 1]).inDays == 1) {
      consecutiveDays++;
    } else {
      if (consecutiveDays > longestStreak) {
        longestStreak = consecutiveDays;
      }
      consecutiveDays = 1;
    }
  }

  // Check if the consecutive days at the end of the list are the longest streak
  if (consecutiveDays > longestStreak) {
    longestStreak = consecutiveDays;
  }

  // Print the result
  return longestStreak;
}
