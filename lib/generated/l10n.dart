// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get langCode {
    return Intl.message(
      'en',
      name: 'langCode',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get languageName {
    return Intl.message(
      'English',
      name: 'languageName',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection is not good!`
  String get badInternetConnection {
    return Intl.message(
      'Internet connection is not good!',
      name: 'badInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get appError {
    return Intl.message(
      'Something went wrong!',
      name: 'appError',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `App`
  String get app {
    return Intl.message(
      'App',
      name: 'app',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Rate the app`
  String get rateTheApp {
    return Intl.message(
      'Rate the app',
      name: 'rateTheApp',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get termsOfUse {
    return Intl.message(
      'Terms of Use',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Data Import & Export`
  String get dataImportAndExport {
    return Intl.message(
      'Data Import & Export',
      name: 'dataImportAndExport',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Reorder Habits`
  String get reorderHabits {
    return Intl.message(
      'Reorder Habits',
      name: 'reorderHabits',
      desc: '',
      args: [],
    );
  }

  /// `Change App Icon`
  String get changeAppIcon {
    return Intl.message(
      'Change App Icon',
      name: 'changeAppIcon',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Delete Habit`
  String get deleteHabit {
    return Intl.message(
      'Delete Habit',
      name: 'deleteHabit',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete {name}?`
  String actForDeletion(Object name) {
    return Intl.message(
      'Are you sure you want to delete $name?',
      name: 'actForDeletion',
      desc: '',
      args: [name],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Show Completion Indicator`
  String get showCompletionIndicator {
    return Intl.message(
      'Show Completion Indicator',
      name: 'showCompletionIndicator',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `name is required.`
  String get nameIsRequired {
    return Intl.message(
      'name is required.',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Habit`
  String get habit {
    return Intl.message(
      'Habit',
      name: 'habit',
      desc: '',
      args: [],
    );
  }

  /// `Habits`
  String get habits {
    return Intl.message(
      'Habits',
      name: 'habits',
      desc: '',
      args: [],
    );
  }

  /// `Create Habit`
  String get createHabit {
    return Intl.message(
      'Create Habit',
      name: 'createHabit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Habit`
  String get editHabit {
    return Intl.message(
      'Edit Habit',
      name: 'editHabit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Remind on these days`
  String get remindOnTheseDays {
    return Intl.message(
      'Remind on these days',
      name: 'remindOnTheseDays',
      desc: '',
      args: [],
    );
  }

  /// `No habits found`
  String get noHabitsFound {
    return Intl.message(
      'No habits found',
      name: 'noHabitsFound',
      desc: '',
      args: [],
    );
  }

  /// `Today's`
  String get todays {
    return Intl.message(
      'Today\'s',
      name: 'todays',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uz'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
