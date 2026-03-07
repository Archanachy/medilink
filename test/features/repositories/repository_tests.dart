import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_availability_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_review_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

class FakeDoctorRepository implements IDoctorRepository {
  @override
  Future<Either<Failure, DoctorAvailabilityEntity>> getDoctorAvailability(String doctorId, String date) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DoctorReviewEntity>>> getDoctorReviews(String doctorId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({String? specialization, String? searchQuery, int? page, int? limit}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> addDoctorReview(String doctorId, double rating, String? comment) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<String>>> getSpecializations() async {
    throw UnimplementedError();
  }
}

void main() {
  test('Repository test placeholder', () {
    final repo = FakeDoctorRepository();
    expect(repo, isA<IDoctorRepository>());
  });
}
