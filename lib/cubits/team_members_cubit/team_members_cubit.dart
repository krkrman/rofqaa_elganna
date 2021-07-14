import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'team_members_state.dart';

class TeamMembersCubit extends Cubit<TeamMembersState> {
  TeamMembersCubit() : super(TeamMembersInitial());

  static TeamMembersCubit get(context) => BlocProvider.of(context);
  CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  List<UserModel?> teamMembersList = [];

  void getTeamMembers() {
    teamMembersList = [];
    UserModel myUserData =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    print(myUserData.teamName);
    if (myUserData.teamName == '') {
      emit(TeamMembersSucceeded());
      return;
    }
    teamsCollection
        .doc(myUserData.teamName)
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        UserModel teamMember = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        teamMembersList.add(teamMember);
      });
      emit(TeamMembersSucceeded());
    }).catchError((error) {
      print(error.toString());
      emit(TeamMembersFailed(error: error));
    });
  }
}
