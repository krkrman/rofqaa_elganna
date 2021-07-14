import 'package:enum_object/enum_object.dart';
import 'package:rofqaa_elganna/helper/utility.dart';

enum UserType { teamMember, teamManager, teamLeader }

class UserModel {
  final String? name, phone;

  final String? imageUrl, teamName;
  UserType? userType;

  UserModel({
    required this.name,
    required this.phone,
    this.imageUrl,
    this.teamName,
    this.userType = UserType.teamMember,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    var enumObject = EnumObject<UserType>(UserType.values);
    return new UserModel(
      name: map['name'] as String,
      phone: map['phone'] as String,
      imageUrl: map['imageUrl'] ?? '',
      teamName: map['teamName'] ?? '',
      userType: enumObject.enumFromString(map['userType']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'phone': this.phone,
      'imageUrl': this.imageUrl,
      'teamName': this.teamName,
      'userType': Utility.convertEnumToString(this.userType),
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'UserModel{name: $name, phone: $phone, imageUrl: $imageUrl, teamName: $teamName, userType: $userType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}
