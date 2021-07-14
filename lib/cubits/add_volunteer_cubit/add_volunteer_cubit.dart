import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'add_volunteer_state.dart';

class AddVolunteerCubit extends Cubit<AddVolunteerState> {
  AddVolunteerCubit() : super(AddVolunteerInitial());

  static AddVolunteerCubit get(BuildContext context) =>
      BlocProvider.of(context);

  CollectionReference _teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(Constants.USERs_COLLECTION);

  void addVolunteer(String phoneNumber) async {
    emit(AddVolunteerLoading());
    if (!await InternetConnectionChecker().hasConnection)
      emit(AddVolunteerHasNoInternetConnection());

    UserModel userModel = UserModel.fromMap(
        Map<String, dynamic>.from(Utility.box.get(Constants.USER)));

    UserModel? volunteerUserModel = await _getUser(phoneNumber);
    if (volunteerUserModel == null) {
      print('Entered before');
      emit(AddVolunteerDoesNotExist());
      return;
    }
    if (volunteerUserModel.teamName == userModel.teamName) {
      emit(VolunteerIsAlreadyExistInTeam());
      return;
    }
    await _updateVolunteerTeam(phoneNumber, userModel.teamName!);
    _teamsCollection
        .doc(userModel.teamName)
        .collection('users')
        .add(volunteerUserModel.toMap())
        .then((value) => emit(AddVolunteerSucceeded()))
        .catchError((error) {
      print(error.toString());
      emit(AddVolunteerFailed(error: error));
    });
  }

  Future<void> _updateVolunteerTeam(String phoneNumber, String teamName) async {
    return _usersCollection
        .doc(phoneNumber)
        .update({'teamName': teamName})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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
}
