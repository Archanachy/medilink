import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  uploadingPhoto,
  success,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileEntity? profile;
  final File? selectedImage;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.selectedImage,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileEntity? Function()? profile,
    File? Function()? selectedImage,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile != null ? profile() : this.profile,
      selectedImage: selectedImage != null ? selectedImage() : this.selectedImage,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage: successMessage != null ? successMessage() : this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        selectedImage,
        errorMessage,
        successMessage,
      ];
}
