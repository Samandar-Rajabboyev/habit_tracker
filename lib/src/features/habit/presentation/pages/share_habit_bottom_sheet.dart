import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/theme/colors.dart';
import 'package:habit_tracker/src/features/habit/data/models/habit.dart';
import 'package:habit_tracker/src/features/habit/presentation/manager/habits/habits_cubit.dart';
import 'package:habit_tracker/src/features/habits/presentation/widgets/habit_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/extensions/image_path.dart';
import '../../../../core/theme/themes.dart';

showShareHabitBottomSheet(BuildContext context, int id) {
  showMaterialModalBottomSheet(
    context: context,
    barrierColor: Clrs.textBlack.withOpacity(.6),
    backgroundColor: context.textLightColor.darken(6),
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return ShareHabitBottomSheet(id: id);
    },
  );
}

class ShareHabitBottomSheet extends StatefulWidget {
  final int id;
  const ShareHabitBottomSheet({Key? key, required this.id}) : super(key: key);

  @override
  State<ShareHabitBottomSheet> createState() => _ShareHabitBottomSheetState();
}

class _ShareHabitBottomSheetState extends State<ShareHabitBottomSheet> {
  String theme = S.current.dark;
  bool showCompletionIndicator = true;
  Habit? habit;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await context.read<HabitsCubit>().getHabit(widget.id).then((value) {
      if (value != null) {
        setState(() {
          theme = context.isDark ? S.current.dark : S.current.light;
          habit = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 28, 0, 15),
        child: Column(
          children: [
            8.ph,
            Screenshot(
              controller: screenshotController,
              child: IgnorePointer(
                child: Theme(
                  data: theme == S.of(context).dark ? darkTheme : lightTheme,
                  child: Builder(
                    builder: (context) {
                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                            decoration: BoxDecoration(color: context.textLightColor.darken(2)),
                            child: HabitCard(
                              viewMode: 2,
                              habit: habit,
                              showIndicator: showCompletionIndicator,
                              onComplete: (String date) {},
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 20,
                            child: Row(
                              children: [
                                Image.asset(
                                  theme == S.of(context).dark ? AppAssets.appIconLight : AppAssets.appIcon,
                                  width: 18,
                                  height: 18,
                                ),
                                6.pw,
                                Text(
                                  'Habit Tracker',
                                  style: TextStyle(
                                    color: context.textDarkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            16.ph,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
              decoration: BoxDecoration(
                color: context.textLightColor.lighten(6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).theme,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: context.textDarkColor,
                          ),
                        ),
                      ),
                      CupertinoSlidingSegmentedControl(
                        children: {
                          S.of(context).light: Text(
                            S.of(context).light,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.textDarkColor,
                            ),
                          ),
                          S.of(context).dark: Text(
                            S.of(context).dark,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.textDarkColor,
                            ),
                          ),
                        },
                        groupValue: theme,
                        onValueChanged: (value) {
                          setState(() {
                            theme = value ?? '';
                          });
                        },
                      ),
                    ],
                  ),
                  16.ph,
                  InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        showCompletionIndicator = !showCompletionIndicator;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).showCompletionIndicator,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: context.textDarkColor,
                            ),
                          ),
                        ),
                        Switch(
                          value: showCompletionIndicator,
                          onChanged: (value) {
                            setState(() {
                              showCompletionIndicator = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  16.ph,
                  Text(
                    S.of(context).color,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: context.textDarkColor,
                    ),
                  ),
                  16.ph,
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
                              color: Clrs.colors[index] == habit?.color?.toColor ? Clrs.baseColor2 : Colors.transparent,
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
                                habit?.color = Clrs.colors[index].hex;
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
                ],
              ),
            ),
            16.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    color: context.isDark ? context.textLightColor.lighten(6) : Clrs.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 32),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 25.w),
                      child: Text(
                        S.of(context).cancel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: context.textDarkColor,
                        ),
                      ),
                    ),
                    press: () => context.popX(),
                  ),
                  CustomButton(
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 32),
                    color: habit?.color?.toColor,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 30.w),
                      child: Text(
                        S.of(context).share,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: context.textLightColor,
                        ),
                      ),
                    ),
                    press: () async {
                      await Permission.storage.request().then((value) async {
                        await getExternalStorageDirectory().then((value) async {
                          String directory = "${value?.path}/habits";
                          await screenshotController
                              .captureAndSave(directory, fileName: "${habit?.name}.png")
                              .then((value) => value == null ? '' : Share.shareFiles([value]));
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
