import 'donation_model.dart';
import 'user_model.dart';

class TeamModel {
  List<UserModel>? users;
  UserModel? teamLeader;
  String? teamName;
  List<DonationModel>? collectedDonations, unCollectedDonations;

  TeamModel({
    this.users,
    required this.teamLeader,
    required this.teamName,
    this.collectedDonations,
    this.unCollectedDonations,
  });

  TeamModel.fromMap(Map<String, dynamic> map) {
    if (map["users"] != null) {
      users = [];
      map["users"].forEach((v) {
        users?.add(UserModel.fromMap(v));
      });
    }
    teamLeader = UserModel.fromMap(map['teamLeader']);
    teamName = map['teamName'] as String;
    collectedDonations = [];
    if (map["collectedDonations"] != null) {
      map["collectedDonations"].forEach((v) {
        collectedDonations!.add(DonationModel.fromMap(v));
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
      'collectedDonations': this.collectedDonations,
      'unCollectedDonations': this.unCollectedDonations,
    } as Map<String, dynamic>;
  }
}
