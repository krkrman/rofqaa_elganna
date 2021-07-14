import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:rofqaa_elganna/cubits/team_members_cubit/team_members_cubit.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

class TeamMembersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeamMembersCubit teamMembersCubit = TeamMembersCubit.get(context);
    teamMembersCubit.getTeamMembers();
    return BlocConsumer<TeamMembersCubit, TeamMembersState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Conditional.single(
            conditionBuilder: (BuildContext context) => state is TeamMembersSucceeded,
            fallbackBuilder: (BuildContext context) =>
                Center(child: CircularProgressIndicator()),
            context: context,
            widgetBuilder: (BuildContext context) {
              return RefreshIndicator(
                onRefresh: () async => teamMembersCubit.getTeamMembers(),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    UserModel teamMember = teamMembersCubit.teamMembersList[index]!;
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: teamMember.imageUrl == null
                            ? CircleAvatar(
                                backgroundImage: AssetImage('assets/logo.jpg'),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(teamMember.imageUrl!),
                              ),
                        title: Text(teamMember.name!),
                        subtitle: Text(teamMember.phone!),
                      ),
                    );
                  },
                  itemCount: teamMembersCubit.teamMembersList.length,
                ),
              );
            });
      },
    );
  }
}
