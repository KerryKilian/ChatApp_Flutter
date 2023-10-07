import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTapFunction;
  const CustomButton({Key? key, required this.text, required this.onTapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTapFunction,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            gradient: LinearGradient(colors: [fourthColor, fifthColor])),
        child: Center(
          child: Text(this.text),
        ),
      ),
    );
  }
}
