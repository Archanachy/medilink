import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/features/medical_records/data/models/medical_record_hive_model.dart';

final medicalRecordLocalDatasourceProvider = Provider<MedicalRecordLocalDatasource>((ref) {
  return MedicalRecordLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class MedicalRecordLocalDatasource {
  final HiveService _hiveService;

  MedicalRecordLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  Future<void> cacheRecords(List<MedicalRecordHiveModel> models) async {
    await _hiveService.cacheMedicalRecords(models);
  }

  Future<List<MedicalRecordHiveModel>> getCachedRecords() async {
    return _hiveService.getCachedMedicalRecords();
  }

  Future<MedicalRecordHiveModel?> getRecordById(String id) async {
    return _hiveService.getMedicalRecordById(id);
  }

  Future<void> clearCache() async {
    await _hiveService.clearMedicalRecords();
  }
}
