import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:core/core.dart';

import '../extensions/image_path.dart';

PreferredSize buildCustomAppBar(
  BuildContext context, {
  bool defaultLeading = false,
  Widget? leading,
  List<Widget>? actions,
  Widget? title,
  Duration? animationDelay,
  Color? blurColor,
}) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, 80),
    child: Blur(
      blur: 40,
      blurColor: blurColor ?? context.textLightColor,
      overlay: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: context.isDark ? Brightness.light : Brightness.dark,
          statusBarIconBrightness: context.isDark ? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        leading: !defaultLeading
            ? leading
            : IconButton(
                onPressed: () => context.popX(),
                icon: SvgPicture.asset(AppAssets.icBack, color: context.iconDarkColor),
              ),
        title: title,
        actions: actions,
      ),
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
      ),
    ).animate().moveY(
          begin: -250,
          end: 0,
          delay: animationDelay ?? const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
        ),
  );
}
