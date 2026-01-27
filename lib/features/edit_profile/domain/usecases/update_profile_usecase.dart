import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/edit_profile/data/repositories/user_profile_repository.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/user_profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? address;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.address,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        userName,
        email,
        phoneNumber,
        dateOfBirth,
        bloodGroup,
        gender,
        address,
      ];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(userProfileRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<UserProfileEntity, UpdateProfileParams> {
  final IUserProfileRepository _repository;

  UpdateProfileUsecase({required IUserProfileRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, UserProfileEntity>> call(
      UpdateProfileParams params) async {
    // Create full name from first and last name
    final fullName = '${params.firstName} ${params.lastName}'.trim();

    final profile = UserProfileEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      fullName: fullName,
      email: params.email,
      userName: params.userName,
      phoneNumber: params.phoneNumber,
      dateOfBirth: params.dateOfBirth,
      bloodGroup: params.bloodGroup,
      gender: params.gender,
      address: params.address,
    );

    return await _repository.updateProfile(profile);
  }
}
