import 'package:hive/hive.dart';
import 'package:medilink/features/prescriptions/data/models/prescription_hive_model.dart';

abstract class IPrescriptionLocalDataSource {
  Future<List<PrescriptionHiveModel>> getPrescriptions();
  Future<PrescriptionHiveModel?> getPrescriptionById(String id);
  Future<void> cachePrescriptions(List<PrescriptionHiveModel> prescriptions);
  Future<void> cachePrescription(PrescriptionHiveModel prescription);
  Future<void> clearCache();
}

class PrescriptionLocalDataSource implements IPrescriptionLocalDataSource {
  static const String _boxName = 'prescriptions';

  Future<Box<PrescriptionHiveModel>> get _box async {
    return await Hive.openBox<PrescriptionHiveModel>(_boxName);
  }

  @override
  Future<List<PrescriptionHiveModel>> getPrescriptions() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<PrescriptionHiveModel?> getPrescriptionById(String id) async {
    final box = await _box;
    return box.values.firstWhere(
      (prescription) => prescription.id == id,
      orElse: () => PrescriptionHiveModel(
        id: '',
        patientId: '',
        doctorId: '',
        doctorName: '',
        medications: [],
        date: DateTime.now(),
        status: '',
      ),
    );
  }

  @override
  Future<void> cachePrescriptions(
      List<PrescriptionHiveModel> prescriptions) async {
    final box = await _box;
    await box.clear();
    for (final prescription in prescriptions) {
      await box.put(prescription.id, prescription);
    }
  }

  @override
  Future<void> cachePrescription(PrescriptionHiveModel prescription) async {
    final box = await _box;
    await box.put(prescription.id, prescription);
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.clear();
  }
}
