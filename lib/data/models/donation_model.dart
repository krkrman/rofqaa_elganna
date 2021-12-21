import 'package:enum_object/enum_object.dart';
import 'package:rofqaa_elganna/data/models/user_model.dart';
import 'package:rofqaa_elganna/helper/utility.dart';

enum DonationKind { roof, waterLink, beds, brideDevices, meals, zakatMoney, public }

class DonationModel {
  final UserModel? userModel;
  final String? contributorName, teamName;
  final String? poorCode;
  final DonationKind? donationKind;
  final int? amount;
  int? id;
  bool? isCollected;

  DonationModel({
    required this.userModel,
    required this.contributorName,
    required this.teamName,
    this.poorCode = 'public',
    required this.donationKind,
    required this.amount,
    this.isCollected = false,
    this.id,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    var enumObject = EnumObject<DonationKind>(DonationKind.values);
    return DonationModel(
      userModel: UserModel.fromMap(map['userModel']),
      contributorName: map['contributorName'] ?? '',
      teamName: map['teamName'] ?? '',
      poorCode: map['poorCode'] ?? '',
      donationKind: enumObject.enumFromString(map['donationKind']),
      amount: map['amount'] as int,
      isCollected: map['isCollected'] as bool,
      id: map['id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'userModel': this.userModel!.toMap(),
      'contributorName': this.contributorName,
      'teamName': this.teamName,
      'poorCode': this.poorCode,
      'donationKind': Utility.convertEnumToString(this.donationKind),
      'amount': this.amount,
      'isCollected': this.isCollected,
      'id': this.id ?? Utility.getRandomNumber(),
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'DonationModel{userModel: $userModel, contributorName: $contributorName, teamName: $teamName, poorCode: $poorCode, donationKind: $donationKind, amount: $amount, id: $id, isCollected: $isCollected}';
  }
}
