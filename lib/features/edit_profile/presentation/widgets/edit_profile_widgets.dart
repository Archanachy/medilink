import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/services/image_picker/image_picker_service.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';

class ImageSelectorWidget extends ConsumerWidget {
  const ImageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final imagePickerService = ref.read(imagePickerServiceProvider);

    return Column(
      children: [
        // Profile Picture Display
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _getProfileImage(profileState),
              child: profileState.status == ProfileStatus.uploadingPhoto
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImageSourceDialog(
                  context,
                  ref,
                  imagePickerService,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (profileState.selectedImage != null)
          TextButton.icon(
            onPressed: () {
              ref.read(profileViewModelProvider.notifier).clearSelectedImage();
            },
            icon: const Icon(Icons.clear),
            label: const Text('Remove selected image'),
          ),
      ],
    );
  }

  ImageProvider? _getProfileImage(ProfileState state) {
    if (state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    } else if (state.profile?.profilePicture != null &&
        state.profile!.profilePicture!.isNotEmpty) {
      return CachedNetworkImageProvider(state.profile!.profilePicture!);
    }
    return null;
  }

  void _showImageSourceDialog(
    BuildContext context,
    WidgetRef ref,
    ImagePickerService imagePickerService,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final file = await imagePickerService.pickFromCamera();
                if (file != null) {
                  ref.read(profileViewModelProvider.notifier).uploadProfilePicture(file);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file = await imagePickerService.pickFromGallery();
                if (file != null) {
                  ref.read(profileViewModelProvider.notifier).uploadProfilePicture(file);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
  );
}
