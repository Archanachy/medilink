import 'package:medilink/features/auth/data/models/auth_api_model.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<AuthHiveModel> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<bool> isEmailExists(String email);
}

abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  
  // NEW METHODS
  Future<bool> forgotPassword(String email);
  Future<bool> resetPassword(String token, String newPassword);
  Future<bool> verifyEmail(String token);
  Future<String> refreshToken(String refreshToken);
  Future<AuthApiModel?> loginWithGoogle(String idToken);
  Future<AuthApiModel?> loginWithApple(String authorizationCode);
}
