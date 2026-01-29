import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/edit_profile/data/models/user_profile_api_model.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return ProfileRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSession,
  );
});

class ProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  /// Get user profile
  Future<UserProfileApiModel> getUserProfile() async {
    final userId = _userSessionService.getCurrentUserId();
    final response = await _apiClient.get(ApiEndpoints.userById(userId!));

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return UserProfileApiModel.fromJson(data);
    }
    throw Exception('Failed to load profile');
  }

  /// Update user profile
  Future<UserProfileApiModel> updateProfile(UserProfileApiModel profile) async {
    final userId = _userSessionService.getCurrentUserId();
    final response = await _apiClient.put(
      ApiEndpoints.userById(userId!),
      data: profile.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedProfile = UserProfileApiModel.fromJson(data);

      // Update session
      await _userSessionService.saveUserSession(
        userId: updatedProfile.id!,
        email: updatedProfile.email,
        fullName: updatedProfile.name,
        userName: updatedProfile.userName,
        phoneNumber: updatedProfile.phoneNumber,
        profilePicture: updatedProfile.profilePicture,
      );

      return updatedProfile;
    }
    throw Exception('Failed to update profile');
  }

  /// Upload profile picture
  Future<String> uploadProfilePicture(File imageFile) async {
    final userId = _userSessionService.getCurrentUserId();
    
    // Create multipart form data
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.userPhoto(userId!),
      formData: formData,
    );

    if (response.data['success'] == true) {
      final photoUrl = response.data['data']['photoUrl'] as String;
      
      // Update session with new photo URL
      final currentEmail = _userSessionService.getCurrentUserEmail();
      final currentName = _userSessionService.getCurrentUserFullName();
      final currentUsername = _userSessionService.getCurrentUserUsername();
      final currentPhone = _userSessionService.getCurrentUserPhoneNumber();

      await _userSessionService.saveUserSession(
        userId: userId,
        email: currentEmail!,
        fullName: currentName!,
        userName: currentUsername!,
        phoneNumber: currentPhone,
        profilePicture: photoUrl,
      );

      return photoUrl;
    }
    throw Exception('Failed to upload photo');
  }
}
