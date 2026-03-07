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

  UserProfileEntity _buildDoctorProfileFromSession() {
    final userId = _userSessionService.getCurrentUserId();
    final fullName =
        (_userSessionService.getCurrentUserFullName() ?? '').trim();
    final userName =
        (_userSessionService.getCurrentUserUsername() ?? '').trim();
    final email = (_userSessionService.getCurrentUserEmail() ?? '').trim();
    final phoneNumber = _userSessionService.getCurrentUserPhoneNumber();
    final profilePicture = _userSessionService.getCurrentUserProfilePicture();
    final role = _userSessionService.getCurrentUserRole();

    final parts =
        fullName.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final firstName = parts.isNotEmpty ? parts.first : 'Doctor';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final safeFullName = fullName.isNotEmpty ? fullName : firstName;

    return UserProfileEntity(
      userId: userId,
      patientId: null,
      firstName: firstName,
      lastName: lastName,
      fullName: safeFullName,
      email: email,
      userName: userName,
      role: role,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      specialization: null,
      qualifications: null,
      experience: null,
      consultationFee: null,
      bio: null,
    );
  }

  /// Load user profile
  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    _patientId = null;

    // Check user role - skip loading for doctors as they don't have patient profiles
    final userRole = _userSessionService.getCurrentUserRole();
    if (userRole?.toLowerCase() == 'doctor') {
      final doctorProfile = _buildDoctorProfileFromSession();
      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: () => doctorProfile,
        selectedImage: () => null,
        errorMessage: () => null,
        successMessage: () => null,
      );
      return;
    }

    final userId = _userSessionService.getCurrentUserId();
    if (userId == null || userId.isEmpty) {
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
        if (profile.patientId != null && profile.patientId!.isNotEmpty) {
          _userSessionService.savePatientId(profile.patientId!);
        }
        final email = _userSessionService.getCurrentUserEmail() ?? '';
        final userName = _userSessionService.getCurrentUserUsername() ?? '';
        final merged = profile.copyWith(email: email, userName: userName);
        state = state.copyWith(
          status: ProfileStatus.loaded,
          profile: () => merged,
        );
      },
    );
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
    String? emergencyContact,
    // Doctor-specific fields
    String? specialization,
    String? qualifications,
    int? experience,
    double? consultationFee,
    String? bio,
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
    final role = _userSessionService.getCurrentUserRole();

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
      role: role,
      emergencyContact: emergencyContact,
      specialization: specialization,
      qualifications: qualifications,
      experience: experience,
      consultationFee: consultationFee,
      bio: bio,
    );

    // Ensure we have a valid patient ID before updating
    if (_patientId == null || _patientId!.isEmpty) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: () => 'Patient ID not found. Please reload your profile.',
      );
      return;
    }

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
