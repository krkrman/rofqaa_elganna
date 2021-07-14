import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/models/team_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'create_team_state.dart';

class CreateTeamCubit extends Cubit<CreateTeamState> {
  CreateTeamCubit() : super(CreateTeamInitial());

  static CreateTeamCubit get(BuildContext context) => BlocProvider.of(context);

  CollectionReference _teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(Constants.USERs_COLLECTION);

  Future<void> createTeam(String teamName, String teamLeaderPhone) async {
    emit(CreateTeamLoading());
    if (!await InternetConnectionChecker().hasConnection)
      emit(CreateTeamHasNoInternetConnection());

    await _updateUserData(teamLeaderPhone, teamName);
    UserModel? teamLeader = await _getUser(teamLeaderPhone);
    if (teamLeader == null) emit(TeamLeaderDoesNotExist());

    TeamModel teamModel = TeamModel(
      teamLeader: teamLeader,
      teamName: teamName,
    );
    _teamsCollection
        .doc(teamName)
        .set(teamModel.toMap())
        .then((value) => emit(CreateTeamSucceeded()))
        .catchError((error) {
      print(error);
      emit(CreateTeamFailed(error: error));
    });
  }

  Future<UserModel?> _getUser(String phoneNumber) async {
    UserModel volUserModel;
    return _usersCollection
        .doc(phoneNumber)
        .get()
        .then((DocumentSnapshot value) {
      volUserModel = UserModel.fromMap(value.data() as Map<String, dynamic>);
      print(volUserModel);
      return volUserModel;
    }).catchError((error) => print(error));
  }

  Future<void> _updateUserData(String phoneNumber, String teamName) async {
    return _usersCollection
        .doc(phoneNumber)
        .update({'teamName': teamName, 'userType': 'teamLeader'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
