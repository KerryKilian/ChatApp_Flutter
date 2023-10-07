import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final double? fontSize;
  final bool title;
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  final backgroundColor;

  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.title = false,
      this.color = primaryColor,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.left,
      this.maxLines = 10,
        this.overflow = TextOverflow.clip,
        this.softWrap = true,
        this.backgroundColor,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(

      text,
      softWrap: softWrap,
      // overflow: this.overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        backgroundColor: backgroundColor,
        fontWeight: fontWeight,
          color: color,
          fontSize: title && fontSize == null
              ? 24
              : title == false && fontSize != null
                  ? fontSize
                  : title == true && fontSize != null
                      ? fontSize
                      : 16),
    );
  }
}
