import 'package:flutter/material.dart';
import 'package:utsav_beladiya/ui/theme/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final TextStyle? style;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle base = TextStyle(
      color: color ?? AppColors.textPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style != null ? base.merge(style) : base,
    );
  }
}


