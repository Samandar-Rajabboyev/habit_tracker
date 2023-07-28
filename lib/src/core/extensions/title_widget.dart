import 'package:flutter/material.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';

extension TitleWidget on String {
  Widget title(BuildContext context) => Text(
        this,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: context.textDarkColor.withOpacity(.6),
        ),
      );
}
