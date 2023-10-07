import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final Color colorOne;
  final Color colorTwo;
  final double padding;
  final double iconSize;
  final Color iconColor;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.colorOne = fourthColor,
    this.colorTwo = fifthColor,
    this.padding = 12,
    this.iconSize = 24,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [colorOne, colorTwo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          )),
    );
  }
}
