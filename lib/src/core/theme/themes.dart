import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'text_styles.dart';

ThemeData lightTheme = FlexColorScheme(
  useMaterial3: true,
  // appBarBackground: lightAppTheme.backgroundBase,
  // scaffoldBackground: lightAppTheme.backgroundBase,
  primary: Clrs.baseColor,
  brightness: Brightness.light,
  fontFamily: appFont,
  appBarElevation: 0,
  applyElevationOverlayColor: false,

  typography: Typography(
    white: whiteTextTheme,
    black: blackTextTheme,
  ),
  textTheme: simpleTextTheme,
  // extensions: const [lightAppTheme],
).toTheme.copyWith(
      appBarTheme: const AppBarTheme(),
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      textTheme: const TextTheme(),
    );

ThemeData darkTheme = FlexColorScheme(
  useMaterial3: true,
  // appBarBackground: darkAppTheme.backgroundBase,
  // scaffoldBackground: darkAppTheme.backgroundBase,
  // primary: darkAppTheme.backgroundBase,
  primary: Clrs.baseColor,
  brightness: Brightness.dark,
  appBarElevation: 0,
  fontFamily: appFont,
  typography: Typography(
    white: whiteTextTheme,
    black: blackTextTheme,
  ),
  textTheme: simpleTextTheme,
  // extensions: const [darkAppTheme],
).toTheme.copyWith(
      appBarTheme: const AppBarTheme(),
      androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      textTheme: const TextTheme(),
    );

setSystemNavigationBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: color));
}
