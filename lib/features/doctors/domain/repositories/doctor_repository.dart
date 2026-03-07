import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_availability_entity.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_review_entity.dart';

abstract interface class IDoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  });
  
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id);
  
  Future<Either<Failure, DoctorAvailabilityEntity>> getDoctorAvailability(
    String doctorId,
    String date,
  );
  
  Future<Either<Failure, List<DoctorReviewEntity>>> getDoctorReviews(
    String doctorId,
  );
  
  Future<Either<Failure, bool>> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  );
  
  Future<Either<Failure, List<String>>> getSpecializations();
}
