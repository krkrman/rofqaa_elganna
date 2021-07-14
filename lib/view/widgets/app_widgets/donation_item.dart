import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/donation_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';
import 'package:rofqaa_elganna/view/widgets/common/custom_text.dart';

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
              text: '${donationModel.amount} LE',
              fontWeight: FontWeight.bold,
            ),
            subtitle: Text(donationModel.userModel!.name!),
            trailing: !donationModel.isCollected!
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.checkCircle),
                      if (userModel == donationModel.userModel)
                        IconButton(
                          onPressed: () {
                            showMaterialModalBottomSheet<void>(
                                context: context,
                                elevation: 20,
                                // gives rounded corner to modal bottom screen
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
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
                                          text: 'Donation QR code',
                                          alignment: Alignment.center,
                                          color: Constants.accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 1,
                                          color: Constants.accentColor,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: QrImage(
                                              data: donationModel.id.toString() +
                                                  userModel.phone!,
                                              version: QrVersions.auto,
                                              size: 320,
                                              gapless: false,
                                              embeddedImage: AssetImage(
                                                  'assets/images/my_embedded_image.png'),
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
                          },
                          icon: Icon(FontAwesomeIcons.qrcode),
                          color: Constants.accentColor,
                        )
                    ],
                  )
                : Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: Constants.accentColor,
                  ),
            onTap: () {
              showMaterialModalBottomSheet<void>(
                context: context,
                elevation: 20,
                // gives rounded corner to modal bottom screen
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                builder: (context) {
                  return Container(
                    height: 250,
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        CustomText(
                          text: 'Donation Data',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Constants.accentColor,
                          alignment: Alignment.center,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(text: 'amount : ${donationModel.amount}'),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(text: 'Contributor name : ${donationModel.contributorName}'),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(
                            text:
                                'donationKind : ${Utility.convertEnumToString(donationModel.donationKind)}'),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(text: 'Volunteer name : ${donationModel.userModel!.name}'),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(text: 'Volunteer phone : ${donationModel.userModel!.phone}'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
