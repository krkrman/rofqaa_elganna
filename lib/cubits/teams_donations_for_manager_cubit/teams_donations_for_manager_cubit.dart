import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/models/team_model.dart';

part 'teams_donations_for_manager_state.dart';

class TeamsDonationsForManagerCubit extends Cubit<TeamsDonationsForManagerState> {
  TeamsDonationsForManagerCubit() : super(TeamsDonationsForManagerInitial());

  static TeamsDonationsForManagerCubit get(context) => BlocProvider.of(context);

  List<TeamModel>? teamsList = [];
  CollectionReference _teamsCollection =
      FirebaseFirestore.instance.collection(Constants.TEAMS_COLLECTION);

  void getAllTeams() {
    teamsList = [];
    emit(TeamsDonationsForManagerLoading());
    _teamsCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data().toString());
        TeamModel teamModel = TeamModel.fromMap(doc.data() as Map<String, dynamic>);
        teamsList!.add(teamModel);
      });
      emit(TeamsDonationsForManagerSucceeded());
    }).catchError((error) {
      print(error.toString());
      emit(TeamsDonationsForManagerFailed());
    });
  }
}
