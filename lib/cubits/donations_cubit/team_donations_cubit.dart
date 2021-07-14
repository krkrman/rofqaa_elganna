import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/team_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'team_donations_state.dart';

class TeamDonationsCubit extends Cubit<TeamDonationsState> {
  TeamDonationsCubit() : super(TeamDonationsInitial());

  static TeamDonationsCubit get(context) => BlocProvider.of(context);
  CollectionReference teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  TeamModel? teamModel;
  int unCollectedMoney = 0;
  int collectedMoney = 0;

  void getTeamDonations() {
    unCollectedMoney = 0;
    collectedMoney = 0;
    emit(TeamDonationsLoading());
    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    teamsCollection.doc(userModel.teamName).get().then((value) {
      print(value.data());
      teamModel = TeamModel.fromMap(value.data() as Map<String, dynamic>);
      for (int i = 0; i < teamModel!.collectedDonations!.length; i++)
        collectedMoney += teamModel!.collectedDonations![i].amount!;
      for (int i = 0; i < teamModel!.unCollectedDonations!.length; i++)
        unCollectedMoney += teamModel!.unCollectedDonations![i].amount!;
      emit(TeamModelSucceeded());
    }).catchError((error) {
      print(error.toString());
      emit(TeamModelFailed());
    });
  }
}
