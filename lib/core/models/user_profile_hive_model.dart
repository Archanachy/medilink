import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';

part 'user_profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userProfileTypeId)
class UserProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? profilePicture;

  @HiveField(5)
  final String role;

  @HiveField(6)
  final DateTime? dateOfBirth;

  @HiveField(7)
  final String? gender;

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final DateTime lastSynced;

  UserProfileHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    required this.role,
    this.dateOfBirth,
    this.gender,
    this.address,
    required this.lastSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'role': role,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
    };
  }
}
