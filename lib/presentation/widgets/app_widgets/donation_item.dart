import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rofqaa_elganna/data/models/donation_model.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';
import 'package:rofqaa_elganna/translation/locale_keys.g.dart';

class DonationItem extends StatelessWidget {
  final DonationModel donationModel;

  const DonationItem({
    required this.donationModel,
  });

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Card(
        elevation: 5,
        child: GestureDetector(
          child: ListTile(
            title: CustomText(
              text: '${donationModel.amount} ${LocaleKeys.LE.tr()}',
              fontWeight: FontWeight.bold,
            ),
            subtitle: Text(donationModel.userModel!.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (donationModel.donationCollection == DonationCollection.withMember)
                  Icon(FontAwesomeIcons.checkCircle),
                if (donationModel.donationCollection == DonationCollection.withTeamLeader)
                  Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: ColorManager.accentColor,
                  ),
                SizedBox(
                  width: 1,
                ),
                if (donationModel.donationCollection == DonationCollection.withTeamManager)
                  Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: ColorManager.accentColor,
                  ),
                if (userModel == donationModel.userModel &&
                    donationModel.donationCollection == UserType.teamMember)
                  IconButton(
                    onPressed: () => showDonationQrCode(context, userModel),
                    icon: Icon(FontAwesomeIcons.qrcode),
                    color: ColorManager.accentColor,
                  )
              ],
            ),
            onTap: () => showDonationDetails(context),
          ),
        ),
      ),
    );
  }

  void showDonationDetails(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      elevation: 20,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      builder: (context) {
        return Container(
          height: 350,
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              CustomText(
                text: LocaleKeys.donationData.tr(),
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: ColorManager.accentColor,
                alignment: Alignment.center,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8,
              ),
              CustomText(text: '${LocaleKeys.amount.tr()} : ${donationModel.amount}'),
              SizedBox(
                height: 8,
              ),
              CustomText(text: '${LocaleKeys.donatorName.tr()} : ${donationModel.contributorName}'),
              SizedBox(
                height: 8,
              ),
              CustomText(
                  text:
                      '${LocaleKeys.donationKind.tr()} : ${Utility.convertEnumToString(donationModel.donationKind).tr()}'),
              SizedBox(
                height: 8,
              ),
              CustomText(text: '${LocaleKeys.volunteerName.tr()} : ${donationModel.userModel!.name}'),
              SizedBox(
                height: 8,
              ),
              CustomText(
                  text: '${LocaleKeys.volunteerPhone.tr()} : ${donationModel.userModel!.phone}'),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        );
      },
    );
  }

  void showDonationQrCode(BuildContext context, UserModel userModel) {
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
                      data: donationModel.id.toString() + userModel.phone,
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
