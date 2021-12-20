import 'package:flutter/material.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double fontSize, height, width, radius;
  final Color? color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isUpperCase;

  const CustomButton({
    required this.text,
    this.fontSize = 18,
    this.height = 55,
    this.width = double.infinity,
    this.radius = 15,
    this.color = ColorManager.accentColor,
    this.textColor = Colors.white,
    required this.onPressed,
    this.isUpperCase = true,
  });


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      elevation: 0,
      minWidth: width,
      color: color?? Theme.of(context).primaryColor,
      height: height,
      child: Center(
        child: CustomText(
          text: text,
          fontSize: fontSize,
          alignment: Alignment.center,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
