import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final TextAlign? alignText;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? weight;
  final Color? color;
  final int? maxWords;
  final int? maxChars;
  final bool underLine;
  final FontStyle? fontStyle;
  final TextStyle? style;
  final double? height;

  const TitleText({
    super.key,
    required this.title,
    this.style,
    this.fontSize,
    this.alignText,
    this.maxLines,
    this.overflow,
    this.weight,
    this.color,
    this.maxWords,
    this.maxChars,
    this.underLine = false,
    this.height,
    this.fontStyle,
  });

  String _truncateByWords(String text, {int maxWords = 3}) {
    final words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  String _truncateByChars(String text, {int maxChars = 30}) {
    if (text.length <= maxChars) {
      return text;
    }
    return '${text.substring(0, maxChars)}...';
  }

  @override
  Widget build(BuildContext context) {
    String displayText = title;
    if (maxWords != null) {
      displayText = _truncateByWords(title, maxWords: maxWords!);
    } else if (maxChars != null) {
      displayText = _truncateByChars(title, maxChars: maxChars!);
    }
    return Text(
      displayText,
      style:
          style ??
          GoogleFonts.spaceGrotesk(
            fontSize: fontSize ?? 14,
            fontWeight: weight ?? FontWeight.normal,
            color: color ?? Theme.of(context).colorScheme.onSurface,
            height: height,
          ),
      textAlign: alignText,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
