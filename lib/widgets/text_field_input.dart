import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String text;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final Color labelColor;
  final int? maxLength;
  final Function? onChanged;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      required this.text,
      required this.textInputType,
        this.hintText = "",
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines = 1,
      this.labelColor = secondaryColor,
      this.maxLength = null,
      this.onChanged,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: labelColor,
          ),
          border: InputBorder.none,
          labelText: text,
          hintText: hintText,
        ),
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: obscureText,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        onChanged: onChanged != null ? (String input) => onChanged! : null
      ),
    );
  }
}
