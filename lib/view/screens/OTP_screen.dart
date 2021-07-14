import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/user_model.dart';
import 'package:rofqaa_elganna/view/screens/home_layout.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/view/widgets/common/pin_code.dart';

class OTPScreen extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final String? verificationId;
  final UserModel userModel;

  OTPScreen({
    required this.verificationId,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    PhoneAuthCubit authCubit = PhoneAuthCubit.get(context);
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is PhoneAuthEmailCreatedSuccessfully) {
          Utility.navigateAndFinish(context, HomeLayout());
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'Login Success',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'Welcome to our Charity',
          )..show();
        } else if (state is PhoneAuthVerificationCompleted) {
          authCubit.createUser(userModel);
        } else if (state is PhoneAuthVerificationFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Error happened',
            desc: state.error,
          )..show();
          print(state.error);
        } else if (state is PhoneAuthEmailCreatedFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Error happened',
            desc: state.error,
          )..show();
        }
      },
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
                      Lottie.asset('assets/mobile_otp.json',
                          repeat: true, height: 300, width: 300),
                      SizedBox(height: 18),
                      CustomText(
                        text: 'OTP Verification',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        alignment: Alignment.center,
                      ),
                      CustomText(
                        text: 'Enter OTP sent to phone : ',
                        alignment: Alignment.center,
                        fontSize: 18,
                      ),
                      SizedBox(height: 30),
                      PinCode(
                        textEditingController: textEditingController,
                        length: 6,
                      ),
                      SizedBox(height: 50),
                      CustomButton(
                          text: 'Verify',
                          onPressed: () {
                            authCubit.signInWithPhoneCredential(verificationId!,
                                textEditingController.text, userModel);
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
