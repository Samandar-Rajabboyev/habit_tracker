import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:core/core.dart';

import '../../../generated/l10n.dart';
import '../theme/colors.dart';
import 'custom_button.dart';

Future<bool?> showActDialog(BuildContext context, String? title, String? description) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title != null
            ? Text(
                title,
                style: TextStyle(color: context.textDarkColor),
              )
            : null,
        content: description != null
            ? Text(
                description,
                style: TextStyle(color: context.textDarkColor),
              )
            : null,
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                CustomButton(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  color: Clrs.oldRose.darken(20),
                  child: Text(S.of(context).yes, textAlign: TextAlign.center),
                  press: () => context.popX(true),
                ),
                8.ph,
                CustomButton(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    S.of(context).no,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.textDarkColor),
                  ),
                  press: () => context.popX(),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
