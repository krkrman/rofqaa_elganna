import 'package:flutter/material.dart';
import 'package:rofqaa_elganna/data/models/donation_model.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';

import 'donation_item.dart';

class TeamDonationsItem extends StatelessWidget {
  final List<DonationModel>? collected;
  final List<DonationModel>? unCollected;
  final int collectedMoney;
  final int unCollectedMoney;

  const TeamDonationsItem({
    required this.collected,
    required this.unCollected,
    required this.collectedMoney,
    required this.unCollectedMoney,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            collectedMoney != 0
                ? CustomText(
                text: 'Collected Money : $collectedMoney LE')
                : SizedBox(),
            SizedBox(height: 5),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: collected!.length,
              itemBuilder: (BuildContext context, int index) {
                return DonationItem(donationModel: collected![index]);
              },
            ),
            SizedBox(height: 10),
            unCollectedMoney != 0
                ? CustomText(
                text:
                'Uncollected Money : $unCollectedMoney LE')
                : SizedBox(),
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
}
