import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/auth/domain/enitities/auth_enitity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String authId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String userName;
  @HiveField(5)
  final String? password;
  @HiveField(6)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userName,
    this.password,
    this.profilePicture,
  }) : authId =authId ?? Uuid().v4();
//From Enitity
  factory AuthHiveModel.fromEntity( AuthEnitity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email:  entity.email,
      phoneNumber: entity.phoneNumber,
      userName: entity.userName,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }
//To Enitity
  AuthEnitity toEntity() {
    return AuthEnitity(
      authId: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      userName: userName,
      password: password,
      profilePicture: profilePicture,
    );  
}
//To Enitity List
  static List<AuthEnitity> toEntityList(List<AuthHiveModel> models){
    return models.map((model) => model.toEntity()).toList();    
  }
  }