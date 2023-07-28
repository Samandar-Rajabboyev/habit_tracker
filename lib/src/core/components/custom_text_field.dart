import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'package:habit_tracker/src/core/extensions/themes.dart';
import 'package:habit_tracker/src/core/extensions/title_widget.dart';
import 'package:habit_tracker/src/core/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? type;
  final int? maxLines;
  final int? minLines;
  final String? label;
  final String? errorText;
  const CustomTextField({
    Key? key,
    this.errorText,
    this.minLines,
    this.maxLines,
    this.label,
    this.controller,
    this.type,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) label!.title(context),
        8.ph,
        TextField(
          onTapOutside: (event) {
            hideKeyboard();
          },
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: type,
          onChanged: onChanged,
          controller: controller,
          style: TextStyle(
            fontSize: 16,
            decorationThickness: 0,
            fontWeight: FontWeight.w500,
            color: context.textDarkColor,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Clrs.coolGray.withOpacity(.3),
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
