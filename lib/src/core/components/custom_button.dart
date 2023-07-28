import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    required this.press,
    this.color,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.disable = false,
  }) : super(key: key);

  final bool disable;
  final Widget? child;
  final Color? color;
  final VoidCallback press;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        elevation: 0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        child: InkWell(
          splashColor: disable ? Colors.transparent : null,
          overlayColor: disable ? MaterialStateProperty.all(Colors.transparent) : null,
          hoverColor: disable ? Colors.transparent : null,
          highlightColor: disable ? Colors.transparent : null,
          focusColor: disable ? Colors.transparent : null,
          onTap: disable ? () {} : press,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ),
    );
  }
}
