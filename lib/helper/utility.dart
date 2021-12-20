import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'constants.dart';

class Utility {
  /// navigate to another screen
  static void navigateTo(BuildContext context, Widget destinationScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
    );
  }

  static void navigateAndFinish(context, widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) {
        return false;
      },
    );
  }

  static var box = Hive.box(Constants.HIVE_BOX);

  static int getRandomNumber() {
    Random random = new Random(DateTime.now().millisecondsSinceEpoch);
    return random.nextInt(2000000000);
  }

  static String convertEnumToString(dynamic enumObject) {
    return enumObject.toString().substring(enumObject.toString().indexOf('.') + 1);
  }

  /// need Flutter Toast
/*
void showToast({
  @required String text,
  @required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}
*/

}

