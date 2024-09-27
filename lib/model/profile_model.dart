import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? bio;

  @HiveField(4)
  String? profilePicture;

  @HiveField(5)
  List<String>? skills;

  @HiveField(6)
  Map<String, String>? socialMediaLinks;

  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.bio,
    this.profilePicture,
    this.skills,
    this.socialMediaLinks,
  });
}
