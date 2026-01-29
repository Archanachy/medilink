import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/edit_profile/data/repositories/user_profile_repository.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/repositories/user_profile_repository.dart';

final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  final repository = ref.read(userProfileRepositoryProvider);
  return GetProfileUsecase(repository: repository);
});

class GetProfileUsecase implements UsecaseWithoutParams<UserProfileEntity> {
  final IUserProfileRepository _repository;

  GetProfileUsecase({required IUserProfileRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, UserProfileEntity>> call() async {
    return await _repository.getUserProfile();
  }
}
