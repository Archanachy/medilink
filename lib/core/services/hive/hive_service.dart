import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/features/auth/data/models/auth_hive_model.dart';
import 'package:medilink/features/appointments/data/models/appointment_hive_model.dart';
import 'package:medilink/features/doctors/data/models/doctor_hive_model.dart';
import 'package:medilink/features/medical_records/data/models/medical_record_hive_model.dart';
import 'package:medilink/features/prescriptions/data/models/prescription_hive_model.dart';
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
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if(!Hive.isAdapterRegistered(HiveTableConstant.doctorTypeId)){
      Hive.registerAdapter(DoctorHiveModelAdapter());
    }

    if(!Hive.isAdapterRegistered(HiveTableConstant.appointmentTypeId)){
      Hive.registerAdapter(AppointmentHiveModelAdapter());
    }

    if(!Hive.isAdapterRegistered(HiveTableConstant.medicalRecordTypeId)){
      Hive.registerAdapter(MedicalRecordHiveModelAdapter());
    }

    if(!Hive.isAdapterRegistered(HiveTableConstant.prescriptionTypeId)){
      Hive.registerAdapter(PrescriptionHiveModelAdapter());
    }

    if(!Hive.isAdapterRegistered(HiveTableConstant.medicationTypeId)){
      Hive.registerAdapter(MedicationHiveModelAdapter());
    }
  }

  //Open all boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<DoctorHiveModel>(HiveTableConstant.doctorTable);
    await Hive.openBox<AppointmentHiveModel>(HiveTableConstant.appointmentTable);
    await Hive.openBox<MedicalRecordHiveModel>(HiveTableConstant.medicalRecordTable);
    await Hive.openBox<PrescriptionHiveModel>(HiveTableConstant.prescriptionTable);
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

 Box<DoctorHiveModel> get _doctorBox =>
   Hive.box<DoctorHiveModel>(HiveTableConstant.doctorTable);

 Box<AppointmentHiveModel> get _appointmentBox =>
   Hive.box<AppointmentHiveModel>(HiveTableConstant.appointmentTable);

 Box<MedicalRecordHiveModel> get _medicalRecordBox =>
   Hive.box<MedicalRecordHiveModel>(HiveTableConstant.medicalRecordTable);

  Future<AuthHiveModel> register(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;

  }
  //Login
  Future<AuthHiveModel?> login(String email, String password) async {
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

  //====================DOCTOR QUERIES====================
  Future<void> cacheDoctors(List<DoctorHiveModel> models) async {
    for (final model in models) {
      await _doctorBox.put(model.id, model);
    }
  }

  List<DoctorHiveModel> getCachedDoctors() {
    return _doctorBox.values.toList();
  }

  DoctorHiveModel? getDoctorById(String id) {
    return _doctorBox.get(id);
  }

  Future<void> clearDoctors() async {
    await _doctorBox.clear();
  }

  //====================APPOINTMENT QUERIES====================
  Future<void> cacheAppointments(List<AppointmentHiveModel> models) async {
    for (final model in models) {
      await _appointmentBox.put(model.id, model);
    }
  }

  List<AppointmentHiveModel> getCachedAppointments() {
    return _appointmentBox.values.toList();
  }

  AppointmentHiveModel? getAppointmentById(String id) {
    return _appointmentBox.get(id);
  }

  Future<void> clearAppointments() async {
    await _appointmentBox.clear();
  }

  //====================MEDICAL RECORD QUERIES====================
  Future<void> cacheMedicalRecords(List<MedicalRecordHiveModel> models) async {
    for (final model in models) {
      await _medicalRecordBox.put(model.id, model);
    }
  }

  List<MedicalRecordHiveModel> getCachedMedicalRecords() {
    return _medicalRecordBox.values.toList();
  }

  MedicalRecordHiveModel? getMedicalRecordById(String id) {
    return _medicalRecordBox.get(id);
  }

  Future<void> clearMedicalRecords() async {
    await _medicalRecordBox.clear();
  }
}