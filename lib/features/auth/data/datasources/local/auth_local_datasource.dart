import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/auth/data/datasources/auth_datasource.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';
//provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // safe fallback — return null if no current user tracking implemented yet
    return Future.value(null);
  }

  @override
  Future<bool> isEmailExists(String email) {
    try{
      final users = _hiveService.isEmailExists(email);
      return Future.value(users);
    }catch(e){
      return Future.value(false); 
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try{
      final user = await _hiveService.login(email, password);
      if(user != null){
        //save to session
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          fullName: user.fullName,
          userName: user.userName,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture ?? '',
        );
      }
      return user;
    }catch(e){
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout()async {
    try{
      await _hiveService.logoutUser();
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }

  }
  
  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async{
    return await _hiveService.register(user);
  }
  


  // @override
  // Future<AuthHiveModel> register(AuthHiveModel user) async {
  //   return await _hiveService.register(user);
  // }
}