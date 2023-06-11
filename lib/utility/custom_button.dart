import 'package:flutter/material.dart';

class CustomAppButton extends MaterialButton {
  CustomAppButton({
    required VoidCallback onPressed,
    required String text,
    Color? color,
    Color? textColor,
    double? fontSize,
    double? borderRadius,
    double? padding,
    EdgeInsets? margin,
  }) : super(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
    ),
    color: color,
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
    ),
    padding: EdgeInsets.all(padding ?? 12.0),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
    minWidth: 0,
    height: 0,
  );
}
