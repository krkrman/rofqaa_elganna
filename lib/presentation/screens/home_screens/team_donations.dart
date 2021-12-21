import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:rofqaa_elganna/data/models/donation_model.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/logic/cubits/donations_cubit/team_donations_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/app_widgets/team_donations_item.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';

class TeamDonationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var teamDonationsCubit = TeamDonationsCubit.get(context);
    UserModel userModel = UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    debugPrint(userModel.toString());
    if (userModel.teamName != '') {
      teamDonationsCubit.getTeamDonations();
    }
    return BlocConsumer<TeamDonationsCubit, TeamDonationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (userModel.teamName != '') {
          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) => state is TeamModelSucceeded,
            widgetBuilder: (BuildContext context) {
              List<DonationModel>? collected = teamDonationsCubit.teamModel!.collectedDonations;
              List<DonationModel>? unCollected =
                  teamDonationsCubit.teamModel!.unCollectedDonations;
              int collectedMoney = teamDonationsCubit.collectedMoney;
              int unCollectedMoney = teamDonationsCubit.unCollectedMoney;

              return RefreshIndicator(
                onRefresh: () async {
                  userModel.teamName != ''
                      ? teamDonationsCubit.getTeamDonations()
                      : () async {};
                },
                child: TeamDonationsItem(
                  unCollected: unCollected,
                  collectedMoney: collectedMoney,
                  collected: collected,
                  unCollectedMoney: unCollectedMoney,
                ),
              );
            },
            fallbackBuilder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else {
          return const Center(
            child: const CustomText(
              text: 'Tell the Team manager to add you to a team',
            ),
          );
        }
      },
    );
  }
}
