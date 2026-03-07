import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/hive/hive_service.dart';
import 'package:medilink/features/appointments/data/models/appointment_hive_model.dart';

final appointmentLocalDatasourceProvider = Provider<AppointmentLocalDatasource>((ref) {
  return AppointmentLocalDatasource(hiveService: ref.read(hiveServiceProvider));
});

class AppointmentLocalDatasource {
  final HiveService _hiveService;

  AppointmentLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  Future<void> cacheAppointments(List<AppointmentHiveModel> models) async {
    await _hiveService.cacheAppointments(models);
  }

  Future<List<AppointmentHiveModel>> getCachedAppointments() async {
    return _hiveService.getCachedAppointments();
  }

  Future<AppointmentHiveModel?> getAppointmentById(String id) async {
    return _hiveService.getAppointmentById(id);
  }

  Future<void> clearCache() async {
    await _hiveService.clearAppointments();
  }
}
