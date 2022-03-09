import 'package:flutter/material.dart';

class BorderLessFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isPassword;
  final bool isClickable;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChange;
  final FormFieldValidator<String>? validate;
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? suffixPressed;
  final GestureTapCallback? onTap;
  final Color? backgroundColor, textColor;
  final double radius;

  const BorderLessFormField({
    required this.controller,
    required this.textInputType,
    this.isPassword = false,
    this.onSubmit,
    this.onChange,
    required this.validate,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixPressed,
    this.isClickable = true,
    this.onTap,
    this.radius = 4,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: backgroundColor ?? Colors.grey[300]),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon:
              suffixIcon != null ? IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon)) : null,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        ),
      ),
    );
  }
}
