import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rofqaa_elganna/data/models/donation_model.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

import '../../../helper/constants.dart';
import 'donation_item.dart';

class TeamDonationsItem extends StatelessWidget {
  final List<DonationModel>? collectedWithTeamLeader;
  final List<DonationModel>? collectedWithTeamManager;

  final List<DonationModel>? unCollected;
  final int collectedWithTeamLeaderMoney;
  final int unCollectedMoney;
  final int collectedWithTeamManagerMoney;

  const TeamDonationsItem({
    required this.collectedWithTeamLeader,
    required this.collectedWithTeamManager,
    required this.unCollected,
    required this.collectedWithTeamLeaderMoney,
    required this.collectedWithTeamManagerMoney,
    required this.unCollectedMoney,
  });

  @override
  Widget build(BuildContext context) {
    log('$collectedWithTeamLeaderMoney   $collectedWithTeamManagerMoney');
    UserModel userModel = UserModel.fromMap(Utility.box.get(Constants.USER));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            if (collectedWithTeamLeaderMoney != 0)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomText(
                      text:
                          '${LocaleKeys.collectedMoneyWithTeamLeader.tr()} : $collectedWithTeamLeaderMoney LE',
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    if (userModel.userType == UserType.teamLeader)
                      IconButton(
                        onPressed: () => _showDonationQrCode(context, userModel),
                        icon: Icon(FontAwesomeIcons.qrcode),
                        color: ColorManager.accentColor,
                      )
                  ],
                ),
              )
            else
              SizedBox(),
            SizedBox(height: 5),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: collectedWithTeamLeader!.length,
              itemBuilder: (BuildContext context, int index) {
                return DonationItem(donationModel: collectedWithTeamLeader![index]);
              },
            ),
            SizedBox(height: 10),
            if (collectedWithTeamManagerMoney != 0)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: CustomText(
                  text:
                      '${LocaleKeys.collectedMoneyWithTeamManager.tr()} : $collectedWithTeamManagerMoney LE',
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              SizedBox(),
            SizedBox(height: 5),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: collectedWithTeamManager!.length,
              itemBuilder: (BuildContext context, int index) {
                return DonationItem(donationModel: collectedWithTeamManager![index]);
              },
            ),
            SizedBox(height: 10),
            if (unCollectedMoney != 0)
              CustomText(
                text: '${LocaleKeys.uncollectedMoney.tr()} : $unCollectedMoney LE',
                fontWeight: FontWeight.bold,
              )
            else
              SizedBox(),
            SizedBox(height: 5),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: unCollected!.length,
              itemBuilder: (BuildContext context, int index) {
                return DonationItem(donationModel: unCollected![index]);
              },
            )
          ],
        ),
      ),
    );
  }

  _showDonationQrCode(BuildContext context, UserModel userModel) {
    showMaterialModalBottomSheet<void>(
        context: context,
        elevation: 20,
        // gives rounded corner to modal bottom screen
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        builder: (context) {
          return Container(
            height: 450,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: LocaleKeys.donationQrCode.tr(),
                  alignment: Alignment.center,
                  color: ColorManager.accentColor,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 1,
                  color: ColorManager.accentColor,
                ),
                Expanded(
                  child: Center(
                    child: QrImage(
                      data: userModel.teamName!,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                      embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(80, 80),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
