import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rofqaa_elganna/cubits/home_cubit/home_cubit.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/user_model.dart';
import 'package:rofqaa_elganna/view/screens/authentication_screen.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeCubit = HomeCubit.get(context);
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    homeCubit.getUser(userModel.phone!);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is HomeSignedOut) {
          Utility.navigateAndFinish(context, AuthenticationScreen());
        } else if (state is HomeGetDonationSucceeded) {
          homeCubit.addDonation(state.donationModel);
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
        }
      },
      builder: (context, state) {
        Widget starterWidget;
        if (userModel.userType == UserType.teamMember)
          starterWidget = homeCubit.memberScreens[homeCubit.index];
        else if (userModel.userType == UserType.teamLeader)
          starterWidget = homeCubit.teamLeaderScreens[homeCubit.index];
        else
          starterWidget = homeCubit.teamManagerScreens[homeCubit.index];

        return Scaffold(
          appBar: AppBar(
            title: Text('Rofqaa'),
            actions: [
              if (userModel.userType == UserType.teamLeader)
                IconButton(
                  onPressed: () async {
                    String qrData;
                    // Platform messages may fail, so we use a try/catch PlatformException.
                    try {
                      qrData = await FlutterBarcodeScanner.scanBarcode(
                          '#ff6666', 'Cancel', true, ScanMode.QR);
                    } on PlatformException {
                      qrData = 'Failed to get platform version.';
                    }
                    //print(donationId);
                    String donationId = qrData.substring(0, qrData.indexOf('+'));
                    String phoneNumber = qrData.substring(qrData.indexOf('+'));
                    homeCubit.getScannedDonation(donationId, phoneNumber);
                  },
                  icon: Icon(Icons.qr_code_scanner),
                ),
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
            ],
          ),
          body: SafeArea(child: starterWidget),
          bottomNavigationBar: ConvexAppBar(
            backgroundColor: Constants.accentColor,
            items: [
              TabItem(icon: FontAwesomeIcons.coins, title: 'Donations'),
              TabItem(icon: FontAwesomeIcons.bitcoin, title: 'Mine'),
              TabItem(icon: Icons.add, title: 'Add'),
              TabItem(icon: Icons.group_outlined, title: 'Members'),
              if (userModel.userType == UserType.teamLeader)
                TabItem(icon: Icons.group_add, title: 'Add Vol'),
              if (userModel.userType == UserType.teamManager)
                TabItem(icon: Icons.add_business_outlined, title: 'Add Team'),
            ],
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int i) => homeCubit.changeScreen(i),
          ),
        );
      },
    );
  }
}
