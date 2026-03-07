import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/prescriptions/data/data_source/local/prescription_local_data_source.dart';
import 'package:medilink/features/prescriptions/data/data_source/remote/prescription_remote_data_source.dart';
import 'package:medilink/features/prescriptions/data/repositories/prescription_repository_impl.dart';
import 'package:medilink/features/prescriptions/domain/repositories/i_prescription_repository.dart';
import 'package:medilink/features/prescriptions/domain/usecases/create_prescription_usecase.dart';
import 'package:medilink/features/prescriptions/domain/usecases/get_prescription_by_id_usecase.dart';
import 'package:medilink/features/prescriptions/domain/usecases/get_prescriptions_usecase.dart';
import 'package:medilink/features/prescriptions/domain/usecases/update_prescription_usecase.dart';

// Data Sources
final prescriptionLocalDataSourceProvider =
    Provider<IPrescriptionLocalDataSource>((ref) {
  return PrescriptionLocalDataSource();
});

// Repository
final prescriptionRepositoryProvider = Provider<IPrescriptionRepository>((ref) {
  final remoteDataSource = ref.watch(prescriptionRemoteDatasourceProvider);
  final localDataSource = ref.watch(prescriptionLocalDataSourceProvider);
  return PrescriptionRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// Use Cases
final getPrescriptionsUsecaseProvider =
    Provider<GetPrescriptionsUsecase>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return GetPrescriptionsUsecase(repository);
});

final getPrescriptionByIdUsecaseProvider =
    Provider<GetPrescriptionByIdUsecase>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return GetPrescriptionByIdUsecase(repository);
});

final createPrescriptionUsecaseProvider =
    Provider<CreatePrescriptionUsecase>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return CreatePrescriptionUsecase(repository);
});

final updatePrescriptionUsecaseProvider =
    Provider<UpdatePrescriptionUsecase>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return UpdatePrescriptionUsecase(repository);
});
