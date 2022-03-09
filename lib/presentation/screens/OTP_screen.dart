import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:rofqaa_elganna/presentation/screens/home_layout.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/pin_code.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class OTPScreen extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserModel userModel;

  OTPScreen({
    required this.userModel,
  });

  void _buildListener(context, state) {
    PhoneAuthCubit authCubit = PhoneAuthCubit.get(context);
    if (state is PhoneAuthUserCreatedSuccessfully) {
      Utility.navigateAndFinish(context, HomeLayout());
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        title: LocaleKeys.loginSuccess.tr(),
        animType: AnimType.BOTTOMSLIDE,
        desc: LocaleKeys.welcomeToOurCharity.tr(),
      )..show();
    } else if (state is PhoneAuthVerificationCompleted) {
      authCubit.createUser(userModel);
    } else if (state is PhoneAuthVerificationFailed) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: LocaleKeys.errorHappened.tr(),
        desc: state.error,
      )..show();
      debugPrint(state.error);
    } else if (state is PhoneAuthUserCreatedFailed) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: LocaleKeys.errorHappened.tr(),
        desc: state.error,
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    PhoneAuthCubit authCubit = PhoneAuthCubit.get(context);
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: _buildListener,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Lottie.asset('assets/mobile_otp.json', repeat: true, height: 300, width: 300),
                      const SizedBox(height: 18),
                      CustomText(
                        text: LocaleKeys.OTPVerification.tr(),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        alignment: Alignment.center,
                      ),
                      CustomText(
                        text: LocaleKeys.enterOTPSentToPhone.tr(),
                        alignment: Alignment.center,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 30),
                      PinCode(
                        textEditingController: textEditingController,
                        length: 6,
                      ),
                      const SizedBox(height: 50),
                      CustomButton(
                          text: LocaleKeys.verify.tr(),
                          onPressed: () {
                            authCubit.submitPinCode(textEditingController.text);
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
