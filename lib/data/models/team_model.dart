import 'donation_model.dart';
import 'user_model.dart';

class TeamModel {
  List<UserModel>? users;
  UserModel? teamLeader;
  String? teamName;
  List<DonationModel>? donationsWithTeamLeader, donationsWithTeamManager, unCollectedDonations;

  TeamModel(
      {this.users,
      required this.teamLeader,
      required this.teamName,
      this.donationsWithTeamLeader,
      this.unCollectedDonations,
      this.donationsWithTeamManager});

  TeamModel.fromMap(Map<String, dynamic> map) {
    if (map["users"] != null) {
      users = [];
      map["users"].forEach((v) {
        users?.add(UserModel.fromMap(v));
      });
    }
    teamLeader = UserModel.fromMap(map['teamLeader']);
    teamName = map['teamName'] as String;
    donationsWithTeamLeader = [];
    if (map["donationsWithTeamLeader"] != null) {
      map["donationsWithTeamLeader"].forEach((v) {
        donationsWithTeamLeader!.add(DonationModel.fromMap(v));
      });
    }
    donationsWithTeamManager = [];
    if (map["donationsWithTeamManager"] != null) {
      map["donationsWithTeamManager"].forEach((v) {
        donationsWithTeamManager!.add(DonationModel.fromMap(v));
      });
    }
    unCollectedDonations = [];
    if (map["unCollectedDonations"] != null) {
      map["unCollectedDonations"].forEach((v) {
        unCollectedDonations!.add(DonationModel.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'teamLeader': this.teamLeader!.toMap(),
      'teamName': this.teamName,
      'donationsWithTeamLeader': this.donationsWithTeamLeader,
      'donationsWithTeamManager': this.donationsWithTeamManager,
      'unCollectedDonations': this.unCollectedDonations,
    } as Map<String, dynamic>;
  }
}
