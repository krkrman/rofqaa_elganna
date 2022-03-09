import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/helper/validators.dart';
import 'package:rofqaa_elganna/logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:rofqaa_elganna/presentation/screens/OTP_screen.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class AuthenticationScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    PhoneAuthCubit authCubit = PhoneAuthCubit.get(context);
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (EasyLoading.isShow) {
          EasyLoading.dismiss();
        }
        if (state is PhoneAuthLoading) {
          EasyLoading.instance
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.dark
            ..radius = 10.0
            ..progressColor = ColorManager.accentColor
            ..backgroundColor = Colors.white24
            ..textColor = ColorManager.accentColor
            ..maskColor = Colors.blue.withOpacity(0.5)
            ..userInteractions = true
            ..dismissOnTap = false;
          EasyLoading.show(
            status: LocaleKeys.loading.tr(),
          );
        } else if (state is PhoneAuthCodeSent) {
          Utility.navigateTo(
              context,
              OTPScreen(
                userModel: userModel!,
              ));
        } else if (state is PhoneAuthVerificationFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: LocaleKeys.errorHappened.tr(),
            desc: state.error,
          )..show();
        } else if (state is PhoneAuthInvalidPhoneNumber) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: LocaleKeys.errorHappened.tr(),
            desc: LocaleKeys.invalidPhoneNumber.tr(),
            animType: AnimType.BOTTOMSLIDE,
          )..show();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  height: 450,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        BorderedFormField(
                          controller: nameController,
                          textInputType: TextInputType.name,
                          validate: RequiredValidator(errorText: LocaleKeys.nameIsRequired.tr()),
                          label: LocaleKeys.name.tr(),
                          prefixIcon: Icons.account_circle_outlined,
                          radius: Constants.radius,
                        ),
                        const SizedBox(height: 15),
                        BorderedFormField(
                          controller: phoneController,
                          textInputType: TextInputType.phone,
                          validate: Validators.phoneValidator,
                          label: LocaleKeys.phoneNumber.tr(),
                          prefixIcon: Icons.phone_android_rounded,
                          radius: Constants.radius,
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          text: LocaleKeys.signIn.tr(),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              userModel = UserModel(
                                  name: nameController.text, phone: '+2${phoneController.text}');
                              authCubit.authenticate(userModel!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
