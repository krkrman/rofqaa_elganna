import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:enum_object/enum_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/data/models/donation_model.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/logic/cubits/add_donation_cubit/add_donation_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/translation/codegen_loader.g.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class AddDonationScreen extends StatelessWidget {
  final amountController = TextEditingController();
  final contributorNameController = TextEditingController();
  final poorCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));

  DonationKind? donationKind;

  @override
  Widget build(BuildContext context) {
    var addDonationCubit = AddDonationCubit.get(context);
    return BlocConsumer<AddDonationCubit, AddDonationState>(listener: (context, state) {
      // TODO: implement listener
      if (addDonationCubit.isDonationStoredInMyDonations &&
          addDonationCubit.isDonationStoredInTeamDonations) {
        EasyLoading.dismiss();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          title: '${LocaleKeys.addedSuccessfully.tr()}',
          animType: AnimType.BOTTOMSLIDE,
          desc: '${LocaleKeys.allahPutThemInYourGoodDeeds.tr()}',
        )..show();
      } else if (state is AddDonationFailed) {
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
          desc: '${LocaleKeys.donationWillBeAddedAsSoonAsThereIsInternetConnection.tr()}',
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
      }
    }, builder: (context, state) {
      if (Utility.box.get(Constants.USER)['teamName'] == '') {
        return Center(
          child: CustomText(
            text: '${LocaleKeys.tellTheTeamLeaderToAddYouToTeam.tr()}',
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Lottie.asset('assets/money.json'),
                  SizedBox(height: 50),
                  BorderedFormField(
                    controller: amountController,
                    textInputType: TextInputType.number,
                    validate: RequiredValidator(errorText: '${LocaleKeys.amountRequired.tr()}'),
                    label: '${LocaleKeys.amount.tr()}',
                    prefixIcon: CommunityMaterialIcons.bitcoin,
                  ),
                  const SizedBox(height: 20),
                  BorderedFormField(
                    controller: contributorNameController,
                    textInputType: TextInputType.name,
                    validate: RequiredValidator(errorText: '${LocaleKeys.donatorNameIsRequired.tr()}'),
                    label: '${LocaleKeys.donatorName.tr()}',
                    prefixIcon: Icons.account_circle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      items: [
                        LocaleKeys.roof.tr(),
                        LocaleKeys.waterLink.tr(),
                        LocaleKeys.beds.tr(),
                        LocaleKeys.brideDevices.tr(),
                        LocaleKeys.meals.tr(),
                        LocaleKeys.zakatMoney.tr(),
                        LocaleKeys.public.tr()
                      ],
                      label: "${LocaleKeys.donationType.tr()}",
                      hint: "${LocaleKeys.donationType.tr()}",
                      //popupItemDisabled: (String s) => s.startsWith('I'),
                      onSaved: (value) {
                        String? key = CodegenLoader.en.keys
                            .firstWhere((k) => CodegenLoader.en[k] == value, orElse: () => '');
                        if (key == '')
                          key = CodegenLoader.ar.keys
                              .firstWhere((k) => CodegenLoader.ar[k] == value, orElse: () => '');
                        debugPrint(key);
                        var enumObject = EnumObject<DonationKind>(DonationKind.values);
                        donationKind = enumObject.enumFromString(key);
                      },
                      selectedItem: LocaleKeys.public.tr()),
                  const SizedBox(
                    height: 20,
                  ),
                  BorderedFormField(
                    controller: poorCodeController,
                    textInputType: TextInputType.name,
                    label: '${LocaleKeys.poorCode.tr()}',
                    validate: (value) => null,
                    prefixIcon: Icons.supervisor_account_outlined,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      text: '${LocaleKeys.donate.tr()}',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          DonationModel donationModel = DonationModel(
                              userModel: userModel,
                              contributorName: contributorNameController.text,
                              teamName: userModel.teamName.toString(),
                              donationKind: donationKind,
                              amount: int.parse(amountController.text));
                          addDonationCubit.addDonation(donationModel);
                        }
                      })
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
