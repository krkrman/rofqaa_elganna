import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/validators.dart';
import 'package:rofqaa_elganna/logic/cubits/add_donation_cubit/add_donation_cubit.dart';
import 'package:rofqaa_elganna/logic/cubits/add_volunteer_cubit/add_volunteer_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class AddVolunteerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<AddVolunteerCubit, AddVolunteerState>(
      listener: (context, state) {
        if (state is AddVolunteerSucceeded) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: '${LocaleKeys.addedSuccessfully.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.allahPutThemInYourGoodDeeds.tr()}',
          )..show();
        } else if (state is AddVolunteerFailed) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: '${LocaleKeys.somethingWrong.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.checkYourInternetConnection.tr()}',
          )..show();
        } else if (state is AddDonationHasNoInternetConnection) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: '${LocaleKeys.noInternetConnection.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'Your Friend will be added as soon as there is internet connection',
          )..show();
        } else if (state is AddDonationLoading) {
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
            status: '${LocaleKeys.loading.tr()}',
          );
        } else if (state is AddVolunteerDoesNotExist) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: '${LocaleKeys.userNotFound.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.thereIsNoUserWithThatPhoneNumber.tr()}',
          )..show();
        } else if (state is VolunteerIsAlreadyExistInTeam) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: '${LocaleKeys.userExists.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.userAlreadyExistsInTeam.tr()}',
          )..show();
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/add_friend.json'),
                const SizedBox(height: 30),
                BorderedFormField(
                  controller: phoneController,
                  textInputType: TextInputType.phone,
                  validate: Validators.phoneValidator,
                  label: '${LocaleKeys.volunteerPhone.tr()}',
                  prefixIcon: Icons.person_add,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    text: '${LocaleKeys.addFriend.tr()}',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AddVolunteerCubit.get(context).addVolunteer('+2${phoneController.text}');
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
