import 'package:form_field_validator/form_field_validator.dart';

/// validate Email and password
class Validators {
  static bool isPasswordValid(String password) {
    if (password.isEmpty) {
      return false;
    } else if (password.length < 8) {
      return false;
    }
    return true;
  }

  static bool isPasswordMatch(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    }
    return false;
  }

  static bool isEmailValid(String email) {
    final Pattern _emailPattern =
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
    return _hasMatch(_emailPattern.toString(), email, caseSensitive: false);
  }

  static bool _hasMatch(String pattern, String input,
          {bool caseSensitive: true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);

  /// to use them pub get this package  form_field_validator: ^1.1.0
  static final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  ]);

  static final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  static final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'phone number is required'),
    MinLengthValidator(10, errorText: 'phone number must be at least 10 digits long'),
  ]);
}
