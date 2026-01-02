import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  //Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    // await _openBoxes();
  }

  //Register all type adapters
  void _registerAdapters() {
    // if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId) == false){
    //   Hive.registerAdapter(AuthHiveModelAdapter());
    // }
  }

  // Delete all batches
  Future<void> deleteAllBatches() async {
    await _authBox.clear();
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // Auth Operations 
  Box get _authBox => Hive.box(HiveTableConstant.authTable);


}
