import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/edit_profile/domain/enitities/user_profile_entity.dart';
import 'package:medilink/features/edit_profile/domain/usecases/get_patient_by_user_id_usecase.dart';
import 'package:medilink/features/edit_profile/domain/usecases/update_patient_usecase.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetPatientByUserIdUsecase _getPatientByUserIdUsecase;
  late final UpdatePatientUsecase _updatePatientUsecase;
  late final UserSessionService _userSessionService;
  String? _patientId;

  @override
  ProfileState build() {
    _getPatientByUserIdUsecase = ref.read(getPatientByUserIdUsecaseProvider);
    _updatePatientUsecase = ref.read(updatePatientUsecaseProvider);
    _userSessionService = ref.read(userSessionServiceProvider);
    return const ProfileState();
  }

  /// Load user profile
  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);

    // Try to use stored patient ID first
    var patientId = _userSessionService.getCurrentPatientId();

    // If no patient ID in session, fetch using user ID
    if (patientId == null) {
      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: () => 'User not found in session',
        );
        return;
      }

      final result = await _getPatientByUserIdUsecase(userId);
      result.fold(
        (failure) {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: () => failure.message,
          );
        },
        (profile) {
          _patientId = profile.patientId;
          // Save patient ID for future use
          _userSessionService.savePatientId(profile.patientId ?? '');
          final email = _userSessionService.getCurrentUserEmail() ?? '';
          final userName = _userSessionService.getCurrentUserUsername() ?? '';
          final merged = profile.copyWith(email: email, userName: userName);
          state = state.copyWith(
            status: ProfileStatus.loaded,
            profile: () => merged,
          );
        },
      );
    } else {
      // Use stored patient ID for faster loading on subsequent calls
      _patientId = patientId;
      final email = _userSessionService.getCurrentUserEmail() ?? '';
      final userName = _userSessionService.getCurrentUserUsername() ?? '';
      // Optionally: refresh from backend using patient ID
      // For now, just mark as loaded and let user refresh if needed
      state = state.copyWith(
        status: ProfileStatus.loaded,
      );
    }
  }

  /// Update profile
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? address,
  }) async {
    state = state.copyWith(status: ProfileStatus.updating);

    if (_patientId == null) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: () => 'Patient record not loaded',
      );
      return;
    }

    final email = _userSessionService.getCurrentUserEmail() ?? '';
    final userName = _userSessionService.getCurrentUserUsername() ?? '';

    final entity = UserProfileEntity(
      userId: _userSessionService.getCurrentUserId(),
      patientId: _patientId,
      firstName: firstName,
      lastName: lastName,
      fullName: '$firstName $lastName'.trim(),
      email: email,
      userName: userName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      gender: gender,
      address: address,
      profilePicture: state.profile?.profilePicture,
    );

    final params = UpdatePatientParams(
      patientId: _patientId!,
      patient: entity,
      profileImage: state.selectedImage,
    );

    final result = await _updatePatientUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: () => failure.message,
        );
      },
      (profile) {
        _patientId = profile.patientId ?? _patientId;
        state = state.copyWith(
          status: ProfileStatus.success,
          profile: () => profile,
          successMessage: () => 'Profile updated successfully',
          selectedImage: () => null,
        );
      },
    );
  }

  /// Select image
  void selectImage(File image) {
    state = state.copyWith(
      selectedImage: () => image,
      status: ProfileStatus.loaded,
    );
  }

  /// Upload profile picture
  Future<void> uploadProfilePicture(File imageFile) async {
    // For patient updates we attach the image during the profile update
    state = state.copyWith(
      selectedImage: () => imageFile,
      status: ProfileStatus.loaded,
    );
  }

  /// Clear selected image
  void clearSelectedImage() {
    state = state.copyWith(
      selectedImage: () => null,
      status: ProfileStatus.loaded,
    );
  }

  /// Reset state
  void reset() {
    state = const ProfileState();
  }
}
