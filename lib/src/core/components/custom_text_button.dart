import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    this.backgroundColor = Colors.white,
    this.textStyle,
    required this.press,
    required this.text,
    this.textColor = Colors.white,
  }) : super(key: key);

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final VoidCallback press;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        textStyle: context.textTheme.labelMedium,
      ),
      onPressed: press,
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }
}
