import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/donation_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'add_donation_state.dart';

class AddDonationCubit extends Cubit<AddDonationState> {
  AddDonationCubit() : super(AddDonationInitial());

  static AddDonationCubit get(BuildContext context) => BlocProvider.of(context);

  CollectionReference donationsCollection =
      FirebaseFirestore.instance.collection(Constants.DONATION_COLLECTION);

  CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  bool isDonationStoredInMyDonations = false;
  bool isDonationStoredInTeamDonations = false;

  void addDonation(DonationModel donationModel) async {
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    emit(AddDonationLoading());
    isDonationStoredInMyDonations = false;
    isDonationStoredInTeamDonations = false;
    if (!await InternetConnectionChecker().hasConnection) {
      emit(AddDonationHasNoInternetConnection());
    }
    if (userModel.userType == UserType.teamLeader) {
      donationModel.isCollected = true;
    }
    Map<String, dynamic> donationModelMap = donationModel.toMap();

    // add to my donations
    donationsCollection
        .doc(userModel.phone)
        .collection('MyDonations')
        .doc(donationModelMap['id'].toString())
        .set(donationModelMap)
        .then((value) {
      isDonationStoredInMyDonations = true;
      emit(AddDonationSucceeded());
    }).catchError((error) {
      print(error.toString());
      emit(AddDonationFailed(error: error.toString()));
    });
    // add to team donations
    if (userModel.userType == UserType.teamLeader) {
      teamsCollection.doc(userModel.teamName).update({
        'collectedDonations': FieldValue.arrayUnion([donationModelMap])
      }).then((value) {
        isDonationStoredInTeamDonations = true;
        emit(AddDonationSucceeded());
      }).catchError((error) {
        print(error.toString());
        emit(AddDonationFailed(error: error.toString()));
      });
    } else {
      teamsCollection.doc(userModel.teamName).update({
        'unCollectedDonations': FieldValue.arrayUnion([donationModelMap])
      }).then((value) {
        isDonationStoredInTeamDonations = true;
        emit(AddDonationSucceeded());
      }).catchError((error) {
        print(error.toString());
        emit(AddDonationFailed(error: error.toString()));
      });
    }
  }
}
