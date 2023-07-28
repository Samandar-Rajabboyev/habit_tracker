import 'dart:math';

import 'package:core/core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/src/core/components/custom_button.dart';
import 'package:habit_tracker/src/core/extensions/date_format.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/extensions/title_widget.dart';
import 'package:habit_tracker/src/core/theme/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/components/custom_appbar.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/locator.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/habit.dart';
import '../manager/habits/habits_cubit.dart';

class CreateHabitScreen extends StatefulWidget {
  final int? id;
  const CreateHabitScreen({Key? key, this.id}) : super(key: key);

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Color color = Clrs.colors.first;
  bool reminder = false;
  final List<ReminderDay> defaultDays = WeekDays.values
      .map((e) => ReminderDay()
        ..weekDay = e.n
        ..notificationId = Random().nextInt((pow(2, 31) - 1).toInt()))
      .toList();
  List<ReminderDay> reminderDays = [];
  String reminderHour = '12:00';
  List<String> completedDates = [];
  String? nameFieldErrorText;

  onSave() {
    if (nameController.text.isEmpty) {
      setState(() {
        nameFieldErrorText = S.current.nameIsRequired;
      });
    } else {
      Habit habit = Habit()
        ..name = nameController.text
        ..description = descriptionController.text
        ..color = color.hex;
      if (widget.id != null) {
        habit.id = widget.id;
        habit.completedDates = completedDates;
      }
      if (reminder) {
        habit.hasReminder = reminder;
        habit.reminderHour = reminderHour;
        habit.reminderDays = reminderDays;
      }
      context.read<HabitsCubit>().createHabit(habit).then((value) => context.popX());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      init();
    } else {
      reminderDays = [...defaultDays];
    }
  }

  init() async {
    LogService.d("${(await locator<NotificationService>().getPendingNotifications()).length}");

    await context.read<HabitsCubit>().getHabit(widget.id!).then((habit) {
      if (habit != null) {
        nameController.text = habit.name ?? '';
        descriptionController.text = habit.description ?? '';
        color = (habit.color?.toColor)!;
        reminder = habit.hasReminder ?? false;
        reminderHour = habit.reminderHour ?? '12:00';
        reminderDays = [...(habit.reminderDays ?? defaultDays)];
        completedDates = [...(habit.completedDates ?? [])];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.id != null
        ? StreamBuilder<Habit?>(
            stream: context.read<HabitsCubit>().habit(widget.id!),
            builder: (context, snapshot) => buildPage(context, snapshot.data))
        : buildPage(context);
  }

  Scaffold buildPage(BuildContext context, [Habit? habit]) {
    return Scaffold(
      backgroundColor: context.textLightColor,
      appBar: buildCustomAppBar(
        context,
        defaultLeading: true,
        animationDelay: const Duration(milliseconds: 100),
        title: Text(
          widget.id == null ? S.of(context).createHabit : S.of(context).editHabit,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: context.textDarkColor,
          ),
        ),
        actions: [
          CustomButton(
            color: Clrs.baseColor2,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            press: onSave,
            child: Text(
              S.of(context).save,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textLightColor,
              ),
            ),
          ),
          16.pw,
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name field
              CustomTextField(
                label: S.of(context).name,
                maxLines: 1,
                controller: nameController,
                onChanged: (v) {
                  setState(() {});
                  if ((nameFieldErrorText?.isNotEmpty ?? false) && v.isNotEmpty) {
                    setState(() => nameFieldErrorText = null);
                  }
                },
                type: TextInputType.text,
                errorText: nameFieldErrorText,
              ),
              16.ph,

              // description field
              CustomTextField(
                label: S.of(context).description,
                controller: descriptionController,
                type: TextInputType.multiline,
                maxLines: 4,
                minLines: 1,
              ),
              16.ph,

              // color field
              S.of(context).color.title(context),
              8.ph,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    Clrs.colors.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignInside,
                          color: Clrs.colors[index] == color ? Clrs.baseColor2 : Colors.transparent,
                        ),
                      ),
                      child: CustomButton(
                        padding: const EdgeInsets.all(6),
                        borderRadius: BorderRadius.circular(8),
                        color: Clrs.coolGray.withOpacity(.3),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Clrs.colors[index],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        press: () {
                          setState(() {
                            color = Clrs.colors[index];
                          });
                        },
                      ).animate().fade(
                            delay: Duration(milliseconds: index * 100),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                          ),
                    ),
                  ),
                ),
              ),
              16.ph,

              // reminder field
              InkWell(
                splashFactory: NoSplash.splashFactory,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashColor: Colors.transparent,
                onTap: () => setState(() => reminder = !reminder),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        S.of(context).reminder.title(context),
                        8.pw,
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: reminder ? 1 : 0,
                          child: CustomButton(
                            press: () async {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: context.textLightColor,
                                builder: (context) {
                                  return SizedBox(
                                    height: 30.h,
                                    child: CupertinoTimerPicker(
                                      initialTimerDuration: reminderHour.hhmmToDuration(),
                                      mode: CupertinoTimerPickerMode.hm,
                                      onTimerDurationChanged: (value) => setState(() => reminderHour = value.toHHMM()),
                                    ),
                                  );
                                },
                              );
                            },
                            color: Clrs.coolGray.withOpacity(.3),
                            child: Text(
                              reminderHour,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: context.textDarkColor.withOpacity(.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: reminder,
                      onChanged: (value) => setState(() => reminder = !reminder),
                    ),
                  ],
                ),
              ),

              // Reminder days
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                child: !reminder
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [SizedBox()],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.ph,
                          S.of(context).remindOnTheseDays.title(context),
                          8.ph,
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                WeekDays.values.length,
                                (index) => CustomButton(
                                  padding: const EdgeInsets.all(6),
                                  borderRadius: BorderRadius.circular(8),
                                  color: reminderDays.any((element) => element.weekDay == WeekDays.values[index].n)
                                      ? Clrs.coolGray
                                      : Clrs.coolGray.withOpacity(.3),
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    child: Text(
                                      WeekDays.values[index].day.shortName2,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: context.textLightColor,
                                      ),
                                    ),
                                  ),
                                  press: () {
                                    if (reminderDays.any((element) => element.weekDay == WeekDays.values[index].n)) {
                                      if (reminderDays.length != 1) {
                                        locator<NotificationService>().cancel(reminderDays
                                            .firstWhere((element) => element.weekDay == WeekDays.values[index].n)
                                            .notificationId);
                                        reminderDays.removeWhere((e) => e.weekDay == WeekDays.values[index].n);
                                      }
                                    } else {
                                      reminderDays.add(ReminderDay()
                                        ..weekDay = WeekDays.values[index].n
                                        ..notificationId = Random().nextInt((pow(2, 31) - 1).toInt()));
                                    }
                                    setState(() {});
                                  },
                                ).animate().fade(
                                      delay: Duration(milliseconds: index * 100),
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.easeOutCubic,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ).animate().moveY(
                begin: -80,
                end: 0,
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
              ),
        ),
      ),
    );
  }
}
