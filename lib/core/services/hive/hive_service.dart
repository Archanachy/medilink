import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});
class HiveService {
  //Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    await openBoxes();
  }

  //Register all type adapters
  void _registerAdapters() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId) == false){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

  }

  //Open all boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);

  }

  // Delete all batches
  Future<void> deleteAllBatches() async {
    await _authBox.clear();
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  //====================AUTH QUERIES====================
 Box<AuthHiveModel> get _authBox =>
   Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> resgisterUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;

  }
  //Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) =>user.email == email && user.password == password,
      );
    if (users.isNotEmpty) {
      return users.first;
    } 
    return null;
  }
  // logout
  Future<void> logoutUser() async {}
  //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // is email exists
  bool isEmailExists(String email) {
    final users =_authBox.values.where(
      (user) =>user.email == email,
      );
    return users.isNotEmpty;
  }
}