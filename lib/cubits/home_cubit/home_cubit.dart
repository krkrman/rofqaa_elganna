import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/donation_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/add_donation_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/add_volunteer_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/create_team_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/my_donations_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/team_donations.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/team_members_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_screens/teams_donations_for_manager.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  List<Widget> memberScreens = [
    TeamDonationsScreen(),
    MyDonationsScreen(),
    AddDonationScreen(),
    TeamMembersScreen(),
  ];

  List<Widget> teamLeaderScreens = [
    TeamDonationsScreen(),
    MyDonationsScreen(),
    AddDonationScreen(),
    TeamMembersScreen(),
    AddVolunteerScreen(),
  ];

  List<Widget> teamManagerScreens = [
    TeamsDonationsForManagerScreen(),
    MyDonationsScreen(),
    AddDonationScreen(),
    TeamMembersScreen(),
    CreateTeamScreen(),
  ];
  int index = 0;

  void signOut() {
    FirebaseAuth.instance.signOut().then((value) => emit(HomeSignedOut()));
  }

  void changeScreen(int i) {
    index = i;
    emit(HomeBottomNavigationBarChanged());
  }

  UserModel? userModel;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Constants.USERs_COLLECTION);

  void getUser(String phoneNumber) async {
    usersCollection.doc(phoneNumber).get().then((DocumentSnapshot value) {
      userModel = UserModel.fromMap(value.data() as Map<String, dynamic>);
      Utility.box.put(Constants.USER, userModel!.toMap());
    });
  }

  CollectionReference donationsCollection =
      FirebaseFirestore.instance.collection(Constants.DONATION_COLLECTION);

  CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  void getScannedDonation(String id, String phoneNumber) {
    emit(HomeGetDonationLoading());
    //UserModel userModel =
    //    UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    donationsCollection.doc(phoneNumber).collection('MyDonations').doc(id).get().then((value) {
      print(value.data());
      DonationModel scannedDonation =
          DonationModel.fromMap(value.data() as Map<String, dynamic>);
      emit(HomeGetDonationSucceeded(donationModel: scannedDonation));
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetDonationFailed(error: id + phoneNumber));
    });
  }

  bool isDonationStoredInMyDonations = false;
  bool isDonationStoredInTeamDonations = false;

  void addDonation(DonationModel donationModel) async {
    isDonationStoredInMyDonations = false;
    isDonationStoredInTeamDonations = false;
    if (!await InternetConnectionChecker().hasConnection) {
      emit(AddDonationHasNoInternetConnection());
    }
    Map<String, dynamic> donationModelMap = donationModel.toMap();
    donationModelMap['isCollected'] = true;
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    // add to my donations
    donationsCollection
        .doc(donationModel.userModel!.phone)
        .collection('MyDonations')
        .doc(donationModelMap['id'].toString())
        .set(donationModelMap)
        .then((value) {
      isDonationStoredInMyDonations = true;
      emit(HomeDonationAddedSuccessfully());
    }).catchError((error) {
      print(error.toString());
      emit(HomeDonationFailed(error: error.toString()));
    });
    // add to team donations
    teamsCollection.doc(userModel.teamName).update({
      'collectedDonations': FieldValue.arrayUnion([donationModelMap])
    }).then((value) {
      isDonationStoredInTeamDonations = true;
      emit(HomeDonationAddedSuccessfully());
    }).catchError((error) {
      print(error.toString());
      emit(HomeDonationFailed(error: error.toString()));
    });
  }

  bool isDonationDeleted = false;

  void deleteUnCollectedDonation(DonationModel donationModel) {
    isDonationDeleted = false;
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    donationModel.isCollected = false;
    print(donationModel);
    teamsCollection.doc(userModel.teamName).update({
      'unCollectedDonations': FieldValue.arrayRemove([donationModel.toMap()])
    }).then((value) {
      emit(HomeDonationDeletedSuccessfully());
      isDonationDeleted = true;
    }).catchError((error) {
      print(error.toString());
      emit(HomeDonationDeletedFailed());
    });
  }
}
