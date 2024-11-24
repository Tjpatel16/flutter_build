import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isTitle;
  final bool isSubtitle;

  const TextWidget(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.weight,
    this.textAlign,
    this.align,
    this.maxLines,
    this.overflow,
    this.isTitle = false,
    this.isSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? align,
      style: isTitle
          ? GoogleFonts.ibmPlexSansCondensed(
              fontSize: size ?? 24,
              fontWeight: weight ?? FontWeight.w600,
              color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
            )
          : isSubtitle
              ? GoogleFonts.ibmPlexSansCondensed(
                  fontSize: size ?? 18,
                  fontWeight: weight ?? FontWeight.w500,
                  color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
                )
              : GoogleFonts.ibmPlexSans(
                  fontSize: size ?? 14,
                  fontWeight: weight ?? FontWeight.w400,
                  color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
                ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
