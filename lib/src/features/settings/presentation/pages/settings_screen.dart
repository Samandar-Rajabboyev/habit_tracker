import 'dart:convert';
import 'dart:io';

import 'package:app_icon_switcher/app_icon_switcher.dart';
import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/src/core/components/custom_action_sheet.dart';
import 'package:habit_tracker/src/core/components/custom_appbar.dart';
import 'package:habit_tracker/src/core/constants/app_constants.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/locator.dart';
import 'package:habit_tracker/src/core/router/app_routes.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../generated/l10n.dart';
import '../../../../app.dart';
import '../../../../core/services/notification_service.dart';
import '../../../habit/data/models/habit.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.isDark ? context.textLightColor : context.textLightColor.darken(),
      appBar: buildCustomAppBar(
        context,
        defaultLeading: true,
        blurColor: context.isDark ? context.textLightColor : context.textLightColor.darken(),
        animationDelay: const Duration(milliseconds: 200),
        title: Text(
          S.of(context).settings,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: context.textDarkColor,
          ),
        ),
      ),
      body: SettingsList(
        applicationType: ApplicationType.both,
        platform: DevicePlatform.iOS,
        brightness: Theme.of(context).brightness,
        darkTheme: SettingsThemeData(
          settingsListBackground: context.textLightColor,
          settingsSectionBackground: context.textLightColor.lighten(),
        ),
        lightTheme: SettingsThemeData(
          settingsSectionBackground: context.textLightColor,
          settingsListBackground: context.textLightColor.darken(),
        ),
        sections: [
          SettingsSection(
            title: Text(S.of(context).app),
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
            tiles: [
              buildThemeTile(ref, context),
              buildLanguageTile(context, ref),
              buildAppIconTile(context),
              SettingsTile.navigation(
                leading: const SizedBox(
                  width: 24,
                  height: 24,
                  child: FittedBox(
                    child: SizedBox(
                      height: 36,
                      width: 37,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Icon(CupertinoIcons.arrow_up_doc_fill),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(CupertinoIcons.arrow_down_doc_fill),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                title: Text(
                  S.of(context).dataImportAndExport,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: (context) async {
                  showCustomActionSheet(
                    context,
                    [
                      CustomAction(
                        'Import',
                        () {
                          importJson(context);
                          context.popX();
                        },
                      ),
                      CustomAction(
                        'Export',
                        () {
                          exportJson();
                          context.popX();
                        },
                      ),
                    ],
                  );
                  // Files.filePicker(
                  //   fileData: FileData(fileMimeType: "isar"),
                  //   onSelected: (fileData) {
                  //     locator<Isar>().copyToFile(fileData.path);
                  //   },
                  // );
                  // if (locator<Isar>().path != null) Share.shareFiles([locator<Isar>().path!]);
                  // await getExternalStorageDirectory().then((value) {
                  //   String directory = "$value/${DateTime.now().millisecondsSinceEpoch}.json";
                  //   (directory).then((value) => Share.shareFiles([directory]));
                  // });
                },
              ),
              buildReorderHabitsTile(context),
            ],
          ),
          SettingsSection(
            title: Text(S.of(context).general),
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(CupertinoIcons.star),
                title: Text(
                  S.of(context).rateTheApp,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: (context) {},
              ),
              SettingsTile.navigation(
                leading: const Icon(CupertinoIcons.lock),
                title: Text(
                  S.of(context).privacyPolicy,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: (context) {},
              ),
              SettingsTile.navigation(
                leading: const Icon(CupertinoIcons.doc_plaintext),
                title: Text(
                  S.of(context).termsOfUse,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: (context) {},
              ),
            ],
          ),
        ],
      ).animate().moveY(
            begin: -80,
            end: 0,
            delay: const Duration(milliseconds: 250),
            duration: const Duration(milliseconds: 900),
            curve: Curves.fastOutSlowIn,
          ),
    );
  }

  SettingsTile buildAppIconTile(BuildContext context) {
    return SettingsTile(
      leading: const Icon(CupertinoIcons.app_badge),
      title: Text(
        S.of(context).changeAppIcon,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FutureBuilder<String?>(
          future: Prefs.getString(AppConstants.keyAppIcon),
          builder: (context, snapshot) {
            return CupertinoSlidingSegmentedControl(
              children: {
                'light': Text(
                  S.of(context).light,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textDarkColor,
                  ),
                ),
                'dark': Text(
                  S.of(context).dark,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textDarkColor,
                  ),
                ),
              },
              groupValue: snapshot.data ?? 'dark',
              onValueChanged: (value) {
                if (value != (snapshot.data ?? 'dark')) {
                  Prefs.setString(AppConstants.keyAppIcon, value ?? 'dark');
                  AppIconSwitcher.updateIcon(value == 'light' ? 'MainActivityLightIcon' : 'MainActivity');
                }
              },
            );
          }),
    );
  }

  SettingsTile buildReorderHabitsTile(BuildContext context) {
    return SettingsTile.navigation(
      leading: const Icon(CupertinoIcons.list_dash),
      title: Text(S.of(context).reorderHabits),
      onPressed: (context) => context.pushNamed(AppRoutes.reorderHabits.name),
    );
  }

  SettingsTile buildLanguageTile(BuildContext context, WidgetRef ref) {
    return SettingsTile.navigation(
      value: Text(
        S.of(context).languageName,
        style: TextStyle(color: context.textDarkColor),
      ),
      leading: const Icon(CupertinoIcons.globe),
      title: Text(
        S.of(context).language,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: (context) {
        showCustomActionSheet(
          context,
          [
            CustomAction(
              'English',
              () {
                ref.read(localeProvider.notifier).changeLocale(Localization.en);
                context.popX();
              },
            ),
            CustomAction(
              'Русский',
              () {
                ref.read(localeProvider.notifier).changeLocale(Localization.ru);
                context.popX();
              },
            ),
            CustomAction(
              'Uzbek',
              () {
                ref.read(localeProvider.notifier).changeLocale(Localization.uz);
                context.popX();
              },
            ),
          ],
        );
      },
    );
  }

  SettingsTile buildThemeTile(WidgetRef ref, BuildContext context) {
    return SettingsTile.navigation(
      value: Text(
        ref.read(themeModeProvider.notifier).name,
        style: TextStyle(color: context.textDarkColor),
      ),
      leading: const Icon(CupertinoIcons.color_filter),
      title: Text(
        S.of(context).theme,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: (context) {
        showCustomActionSheet(
          context,
          [
            CustomAction(
              S.of(context).system,
              () {
                ref.read(themeModeProvider.notifier).changeMode(ThemeMode.system);
                context.popX();
              },
            ),
            CustomAction(
              S.of(context).light,
              () {
                ref.read(themeModeProvider.notifier).changeMode(ThemeMode.light);
                context.popX();
              },
            ),
            CustomAction(
              S.of(context).dark,
              () {
                ref.read(themeModeProvider.notifier).changeMode(ThemeMode.dark);
                context.popX();
              },
            ),
          ],
        );
      },
    );
  }
}

importJson(BuildContext context) async {
  await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  ).then((fileData) async {
    if (fileData?.paths.first != null) {
      try {
        LogService.i("${fileData?.paths.first}");
        final data = await File((fileData?.paths.first)!).readAsString();
        final jsonData = jsonDecode(data) as List<dynamic>;

        final isarCollection = locator<Isar>().habits;

        final models = jsonData
            .map((json) => Habit()
              ..name = json['name']
              ..description = json['description']
              ..order = json['order']
              ..color = json['color']
              ..hasReminder = json['hasReminder']
              ..reminderDays = (json['reminderDays'] as List?)
                  ?.map<ReminderDay>((e) => ReminderDay()
                    ..weekDay = int.parse("$e".split(':').first)
                    ..notificationId = int.parse("$e".split(':').last))
                  .toList()
              ..reminderHour = json['reminderHour']
              ..completedDates = (json['completedDates'] as List?)?.map((e) => e.toString()).toList())
            .toList();

        locator<Isar>().writeTxn(() async {
          for (var habit in models) {
            if (habit.hasReminder ?? false) {
              habit.reminderDays?.forEach((element) {
                locator<NotificationService>().scheduledNotification(
                  title: habit.name ?? '_',
                  body: "It's time to add a completion to ${habit.name}",
                  weekday: element.weekDay!,
                  hour: int.parse((habit.reminderHour?.split(':').first ?? '8')),
                  minutes: int.parse((habit.reminderHour?.split(':').last ?? '0')),
                  id: element.notificationId!,
                );
              });
            }
          }
          await isarCollection.putAll(models);
        });
      } catch (e) {
        LogService.e("$e");
      }
    }
  });
}

exportJson() async {
  final isarCollection = locator<Isar>().habits;

  final models = await isarCollection.filter().colorIsNotEmpty().findAll();

  final jsonData = models
      .map((model) => {
            'name': model.name,
            'description': model.description,
            'order': model.order,
            'color': model.color,
            'hasReminder': model.hasReminder,
            'reminderDays': model.reminderDays?.map((e) => '${e.weekDay}:${e.notificationId}'),
            'reminderHour': model.reminderHour,
            'completedDates': model.completedDates,
          })
      .toList();

  final jsonString = jsonEncode(jsonData);
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/${DateTime.now()}.json');
  await file.writeAsString(jsonString).then((value) => Share.shareFiles([value.path]));
}
