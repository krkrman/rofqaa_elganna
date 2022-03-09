import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/validators.dart';
import 'package:rofqaa_elganna/logic/cubits/create_team_cubit/create_team_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class CreateTeamScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final teamNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTeamCubit, CreateTeamState>(
      listener: (context, state) {
        if (state is CreateTeamSucceeded) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: '${LocaleKeys.createdSuccessfully.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.allahPutThemInYourGoodDeeds.tr()}',
          )..show();
        } else if (state is CreateTeamFailed) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: '${LocaleKeys.somethingWrong.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.checkYourInternetConnection.tr()}',
          )..show();
        } else if (state is CreateTeamLoading) {
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
        } else if (state is CreateTeamHasNoInternetConnection) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: '${LocaleKeys.noInternetConnection.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.teamWillBeAddedAsSoonAsThereIsInternetConnection.tr()}',
          )..show();
        } else if (state is TeamLeaderDoesNotExist) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: '${LocaleKeys.userNotFound.tr()}',
            animType: AnimType.BOTTOMSLIDE,
            desc: '${LocaleKeys.thereIsNoUserWithThatPhoneNumber.tr()}',
          )..show();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/add_friend.json'),
                  SizedBox(height: 30),
                  BorderedFormField(
                    controller: teamNameController,
                    textInputType: TextInputType.name,
                    validate: RequiredValidator(errorText: '${LocaleKeys.requiredField.tr()}'),
                    label: '${LocaleKeys.teamName.tr()}',
                    prefixIcon: Icons.group_rounded,
                  ),
                  SizedBox(height: 30),
                  BorderedFormField(
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    validate: Validators.phoneValidator,
                    label: '${LocaleKeys.teamLeaderPhone.tr()}',
                    prefixIcon: Icons.person_add,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: '${LocaleKeys.addTeam.tr()}',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CreateTeamCubit.get(context)
                            .createTeam(teamNameController.text, '+2${phoneController.text}');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
