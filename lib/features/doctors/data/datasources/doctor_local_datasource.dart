import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/features/doctors/data/models/doctor_hive_model.dart';

final doctorLocalDatasourceProvider = Provider<DoctorLocalDatasource>((ref) {
  return DoctorLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class DoctorLocalDatasource {
  final HiveService _hiveService;

  DoctorLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  Future<void> cacheDoctors(List<DoctorHiveModel> models) async {
    await _hiveService.cacheDoctors(models);
  }

  Future<List<DoctorHiveModel>> getCachedDoctors() async {
    return _hiveService.getCachedDoctors();
  }

  Future<DoctorHiveModel?> getDoctorById(String id) async {
    return _hiveService.getDoctorById(id);
  }

  Future<void> clearCache() async {
    await _hiveService.clearDoctors();
  }
}
