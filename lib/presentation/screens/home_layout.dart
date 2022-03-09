import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/logic/cubits/home_cubit/home_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

import 'authentication_screen.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeCubit = HomeCubit.get(context);
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    homeCubit.getUser(userModel.phone);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeSignedOut) {
          Utility.navigateAndFinish(context, AuthenticationScreen());
        } else if (state is HomeGetDonationSucceeded) {
          homeCubit.collectDonationWithTeamLeader(state.donationModel);
          homeCubit.deleteUnCollectedDonation(state.donationModel);
        } else if (state is HomeGetDonationFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: state.error,
            animType: AnimType.BOTTOMSLIDE,
          )..show();
        } else if (homeCubit.isDonationDeleted &&
            homeCubit.isDonationStoredInTeamDonations &&
            homeCubit.isDonationStoredInMyDonations) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'Added Successfully',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'Allah put them in your good deeds',
          )..show();
        } else if (state is HomeImageUploadingFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: 'Uploading Error',
            animType: AnimType.BOTTOMSLIDE,
            desc: 'Error happened while uploading your image',
          )..show();
        }
      },
      builder: (context, state) {
        UserModel _userModel =
            UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
        Widget starterWidget;
        debugPrint(_userModel.toString());
        if (_userModel.userType == UserType.teamMember)
          starterWidget = homeCubit.memberScreens[homeCubit.index];
        else if (_userModel.userType == UserType.teamLeader)
          starterWidget = homeCubit.teamLeaderScreens[homeCubit.index];
        else
          starterWidget = homeCubit.teamManagerScreens[homeCubit.index];

        return Scaffold(
            appBar: AppBar(
              title: Text('Rofqaa'),
              leading: InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  homeCubit.uploadImage(image);
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _userModel.imageUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(_userModel.imageUrl!),
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage('assets/logo.jpg'),
                          )),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          title: 'Sign out',
                          animType: AnimType.BOTTOMSLIDE,
                          desc: 'Are you sure you want to sign out ?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            homeCubit.signOut();
                          })
                        ..show();
                    },
                    icon: Icon(FontAwesomeIcons.signOutAlt)),
                PopupMenuButton(itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: context.locale.toString() == 'en'
                          ? InkWell(
                              onTap: () => context.setLocale(Locale('ar')),
                              child: CustomText(text: 'عربي'))
                          : InkWell(
                              onTap: () => context.setLocale(Locale('en')),
                              child: CustomText(text: 'English')),
                      value: 1,
                    )
                  ];
                })
              ],
            ),
            body: SafeArea(child: starterWidget),
            bottomNavigationBar: ConvexAppBar(
              height: 52,
              backgroundColor: ColorManager.accentColor,
              items: [
                TabItem(icon: FontAwesomeIcons.coins, title: LocaleKeys.donations.tr()),
                TabItem(icon: FontAwesomeIcons.bitcoin, title: LocaleKeys.mine.tr()),
                TabItem(icon: Icons.add, title: LocaleKeys.add.tr()),
                TabItem(icon: Icons.group_outlined, title: LocaleKeys.members.tr()),
                if (_userModel.userType == UserType.teamLeader)
                  TabItem(icon: Icons.group_add, title: LocaleKeys.addVol.tr()),
                if (_userModel.userType == UserType.teamManager)
                  TabItem(icon: Icons.add_business_outlined, title: LocaleKeys.addTeam.tr()),
              ],
              initialActiveIndex: 0,
              //optional, default as 0
              onTap: (int i) => homeCubit.changeScreen(i),
            ),
            floatingActionButton: _userModel.userType != UserType.teamMember
                ? FloatingActionButton(
                    backgroundColor: ColorManager.accentColor,
                    child: const Icon(Icons.qr_code_scanner),
                    onPressed: () => homeCubit.scanQrCode(_userModel.userType!),
                  )
                : null);
      },
    );
  }
}
