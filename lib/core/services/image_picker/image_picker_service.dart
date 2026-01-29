import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilink/core/services/permission/permission_service.dart';

final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  final permissionService = ref.read(permissionServiceProvider);
  return ImagePickerService(permissionService: permissionService);
});

class ImagePickerService {
  final PermissionService _permissionService;
  final ImagePicker _picker = ImagePicker();

  ImagePickerService({required PermissionService permissionService})
      : _permissionService = permissionService;

  /// Pick image from camera
  Future<File?> pickFromCamera() async {
    final hasPermission = await _permissionService.requestCameraPermission();
    if (!hasPermission) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      return image != null ? File(image.path) : null;
    } catch (e) {
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickFromGallery() async {
    final hasPermission = await _permissionService.requestPhotoPermission();
    if (!hasPermission) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      return image != null ? File(image.path) : null;
    } catch (e) {
      return null;
    }
  }
}
