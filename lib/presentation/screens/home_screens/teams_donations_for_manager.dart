import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:rofqaa_elganna/data/models/team_model.dart';
import 'package:rofqaa_elganna/helper/color_manager.dart';
import 'package:rofqaa_elganna/logic/cubits/teams_donations_for_manager_cubit/teams_donations_for_manager_cubit.dart';
import 'package:rofqaa_elganna/presentation/widgets/app_widgets/team_donations_item.dart';
import 'package:rofqaa_elganna/presentation/widgets/common/custom_text.dart';

class TeamsDonationsForManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeamsDonationsForManagerCubit.get(context).getAllTeams();
    return BlocConsumer<TeamsDonationsForManagerCubit, TeamsDonationsForManagerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
                state is TeamsDonationsForManagerSucceeded,
            widgetBuilder: (BuildContext context) {
              List<TeamModel>? teamsList = TeamsDonationsForManagerCubit.get(context).teamsList;
              return RefreshIndicator(
                onRefresh: () async => TeamsDonationsForManagerCubit.get(context).getAllTeams(),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      TeamModel currentTeam = teamsList![index];
                      int collectedMoney = 0, unCollectedMoney = 0;
                      currentTeam.collectedDonations!.forEach((element) {
                        collectedMoney += element.amount!;
                      });
                      currentTeam.unCollectedDonations!.forEach((element) {
                        unCollectedMoney += element.amount!;
                      });
                      return ExpandablePanel(
                        header: CustomText(
                          text: currentTeam.teamName!,
                          padding: 15,
                        ),
                        collapsed: const SizedBox(),
                        expanded: TeamDonationsItem(
                          collectedMoney: collectedMoney,
                          unCollectedMoney: unCollectedMoney,
                          collected: currentTeam.collectedDonations,
                          unCollected: currentTeam.unCollectedDonations,
                        ),
                        theme: const ExpandableThemeData(
                            hasIcon: true,
                            tapHeaderToExpand: true,
                            animationDuration: const Duration(milliseconds: 500),
                            iconColor: ColorManager.accentColor,
                            collapseIcon: Icons.arrow_downward),
                        //tapHeaderToExpand: true,
                        //hasIcon: true,
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                    itemCount: teamsList!.length),
              );
            },
            fallbackBuilder: (BuildContext context) =>
                Center(child: CircularProgressIndicator()));
      },
    );
  }
}
