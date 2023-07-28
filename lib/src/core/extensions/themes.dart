import 'package:flutter/material.dart';

import '../theme/colors.dart';

extension Theming on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  bool get isDark => appTheme.brightness == Brightness.dark;

  // AppTheme get appColors => Theme.of(this).extension<AppTheme>()!;

  Color get textDarkColor => isDark ? Clrs.textWhite : Clrs.textBlack;
  Color get textLightColor => isDark ? Clrs.textBlack : Clrs.textWhite;

  Color get iconDarkColor => isDark ? Clrs.textWhite10 : Clrs.textGray;
  Color get iconLightColor => isDark ? Clrs.textGray : Clrs.textWhite10;

  TextTheme get textTheme => isDark ? appTheme.typography.white : appTheme.typography.black;
}
