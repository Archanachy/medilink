import 'package:equatable/equatable.dart';
import 'package:medilink/features/medical_records/domain/entities/medical_record_entity.dart';

enum MedicalRecordStatus { initial, loading, success, error }

class MedicalRecordState extends Equatable {
  final MedicalRecordStatus status;
  final List<MedicalRecordEntity> records;
  final MedicalRecordEntity? selectedRecord;
  final String? errorMessage;

  const MedicalRecordState({
    this.status = MedicalRecordStatus.initial,
    this.records = const [],
    this.selectedRecord,
    this.errorMessage,
  });

  MedicalRecordState copyWith({
    MedicalRecordStatus? status,
    List<MedicalRecordEntity>? records,
    MedicalRecordEntity? selectedRecord,
    String? errorMessage,
  }) {
    return MedicalRecordState(
      status: status ?? this.status,
      records: records ?? this.records,
      selectedRecord: selectedRecord ?? this.selectedRecord,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, records, selectedRecord, errorMessage];
}
