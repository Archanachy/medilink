class HiveTableConstant {
  HiveTableConstant._();

  //Database name
  static const String dbName = 'medilink_dart';

  static const int authTypeId = 0;
  static const String authTable = 'auth_table';

  static const int doctorTypeId = 1;
  static const String doctorTable = 'doctor_table';

  static const int appointmentTypeId = 2;
  static const String appointmentTable = 'appointment_table';

  static const int medicalRecordTypeId = 3;
  static const String medicalRecordTable = 'medical_record_table';

  static const int prescriptionTypeId = 10;
  static const String prescriptionTable = 'prescription_table';
  
  static const int medicationTypeId = 11;

  static const int queuedActionTypeId = 15;
  static const String queuedActionTable = 'queued_action_table';

  static const int userProfileTypeId = 16;
  static const String userProfileTable = 'user_profile_table';
}
