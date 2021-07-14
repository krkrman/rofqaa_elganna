import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/cubits/create_team_cubit/create_team_cubit.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/validators.dart';
import 'package:rofqaa_elganna/view/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_button.dart';

class CreateTeamScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final teamNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTeamCubit, CreateTeamState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CreateTeamSucceeded) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'Created Successfully',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'Allah put his work in your good deeds',
          )..show();
        } else if (state is CreateTeamFailed) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: 'Something wrong',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'check your internet',
          )..show();
        } else if (state is CreateTeamLoading) {
          EasyLoading.instance
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.dark
            ..radius = 10.0
            ..progressColor = Constants.accentColor
            ..backgroundColor = Colors.white24
            ..textColor = Constants.accentColor
            ..maskColor = Colors.blue.withOpacity(0.5)
            ..userInteractions = true
            ..dismissOnTap = false;
          EasyLoading.show(
            status: 'Loading...',
          );
        } else if (state is CreateTeamHasNoInternetConnection) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: 'No Internet Connection',
            animType: AnimType.BOTTOMSLIDE,
            desc:
                'Your Friend will be added as soon as there is internet connection',
          )..show();
        } else if (state is TeamLeaderDoesNotExist) {
          EasyLoading.dismiss();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            title: 'User is not found',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'there is no user with that phone number',
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
                    validate: RequiredValidator(errorText: 'Required field'),
                    label: 'Team Name',
                    prefixIcon: Icons.group_rounded,
                  ),
                  SizedBox(height: 30),
                  BorderedFormField(
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    validate: Validators.phoneValidator,
                    label: 'Team Leader phone',
                    prefixIcon: Icons.person_add,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: 'Add Team',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CreateTeamCubit.get(context).createTeam(
                            teamNameController.text,
                            '+2${phoneController.text}');
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
