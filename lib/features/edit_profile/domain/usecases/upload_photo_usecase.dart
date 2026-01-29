import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/edit_profile/data/repositories/user_profile_repository.dart';
import 'package:medilink/features/edit_profile/domain/repositories/user_profile_repository.dart';

// Params class
class UploadPhotoParams extends Equatable {
  final File imageFile;

  const UploadPhotoParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}

// Provider
final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final repository = ref.read(userProfileRepositoryProvider);
  return UploadPhotoUsecase(repository: repository);
});

// Usecase implementation
class UploadPhotoUsecase implements UsecaseWithParams<String, UploadPhotoParams> {
  final IUserProfileRepository _repository;

  // Validation constants
  static const int maxFileSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedFormats = ['jpg', 'jpeg', 'png', 'gif'];

  UploadPhotoUsecase({required IUserProfileRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) async {
    // Validate file
    final validationResult = _validateFile(params.imageFile);
    if (validationResult != null) {
      return Left(validationResult);
    }

    // Upload if validation passes
    return await _repository.uploadProfilePicture(params.imageFile);
  }

  /// Validate file existence, size, and format
  Failure? _validateFile(File file) {
    // Check if file exists
    if (!file.existsSync()) {
      return const LocalDatabaseFailure(
        message: 'Image file does not exist. Please select a valid image.',
      );
    }

    // Check file size
    final fileSize = file.lengthSync();
    if (fileSize > maxFileSizeInBytes) {
      final sizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
      return LocalDatabaseFailure(
        message: 'Image size ($sizeMB MB) exceeds the 5MB limit. Please choose a smaller image.',
      );
    }

    // Check file format
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedFormats.contains(extension)) {
      return LocalDatabaseFailure(
        message: 'Unsupported image format ($extension). Please use JPG, PNG, or GIF.',
      );
    }

    return null; // All validations passed
  }
}
