import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:enum_object/enum_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:rofqaa_elganna/cubits/add_donation_cubit/add_donation_cubit.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/donation_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';
import 'package:rofqaa_elganna/view/widgets/common/bordered_form_field.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_button.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_text.dart';

class AddDonationScreen extends StatelessWidget {
  final amountController = TextEditingController();
  final contributorNameController = TextEditingController();
  final poorCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel userModel =
      UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));

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
          title: 'Added Successfully',
          animType: AnimType.BOTTOMSLIDE,
          desc: 'Allah put them in your good deeds',
        )..show();
      } else if (state is AddDonationFailed) {
        EasyLoading.dismiss();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          title: 'Something wrong',
          animType: AnimType.BOTTOMSLIDE,
          desc: 'check your internet',
        )..show();
      } else if (state is AddDonationHasNoInternetConnection) {
        EasyLoading.dismiss();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          title: 'No Internet Connection',
          animType: AnimType.BOTTOMSLIDE,
          desc: 'donation will be added as soon as there is internet connection',
        )..show();
      } else if (state is AddDonationLoading) {
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
      }
    }, builder: (context, state) {
      if (Utility.box.get(Constants.USER)['teamName'] == '') {
        return Center(
          child: CustomText(
            text: 'Tell the Team manager to add you to a team',
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
                    validate: RequiredValidator(errorText: 'Amount is Required'),
                    label: 'Amount',
                    prefixIcon: CommunityMaterialIcons.bitcoin,
                  ),
                  SizedBox(height: 20),
                  BorderedFormField(
                    controller: contributorNameController,
                    textInputType: TextInputType.name,
                    validate: RequiredValidator(errorText: 'Contributor name is Required'),
                    label: 'Contributor name',
                    prefixIcon: Icons.account_circle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      items: [
                        'roof',
                        'waterLink',
                        'beds',
                        'brideDevices',
                        'meals',
                        'zakatMoney',
                        'public'
                      ],
                      label: "Menu mode",
                      hint: "country in menu mode",
                      //popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (value) {
                        var enumObject = EnumObject<DonationKind>(DonationKind.values);
                        donationKind = enumObject.enumFromString(value);
                      },
                      selectedItem: "public"),
                  SizedBox(
                    height: 20,
                  ),
                  BorderedFormField(
                    controller: poorCodeController,
                    textInputType: TextInputType.name,
                    label: 'Poor code',
                    validate: (value) => null,
                    prefixIcon: Icons.supervisor_account_outlined,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      text: 'Donate',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
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
