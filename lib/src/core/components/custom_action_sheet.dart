import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:core/core.dart';

import '../../../generated/l10n.dart';

showCustomActionSheet(BuildContext context, List<CustomAction> actions) {
  showCustomModalBottomSheet(
    context: context,
    builder: (context) {
      return Theme(
        data: ThemeData(brightness: Theme.of(context).brightness),
        child: CupertinoActionSheet(
          actions: actions.map((e) => CupertinoActionSheetAction(onPressed: e.onTap, child: Text(e.title))).toList(),
          cancelButton: CupertinoActionSheetAction(onPressed: () => context.popX(), child: Text(S.of(context).cancel)),
        ),
      );
    },
    containerWidget: (BuildContext context, Animation<double> animation, Widget child) {
      return child;
    },
  );
}

class CustomAction {
  final String title;
  final Function() onTap;

  CustomAction(this.title, this.onTap);
}
