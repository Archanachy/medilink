import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/edit_profile/presentation/states/profile_state.dart';
import 'package:medilink/features/edit_profile/presentation/view_model/profile_view_model.dart';
import 'package:medilink/features/edit_profile/presentation/widgets/edit_profile_widgets.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _bloodGroupController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    // Listen for state changes
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage ?? 'Success')),
        );
      } else if (next.status == ProfileStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error')),
        );
      }
    });

    // Populate controllers when profile is loaded
    if (profileState.status == ProfileStatus.loaded &&
        _firstNameController.text.isEmpty) {
      _firstNameController.text = profileState.profile?.firstName ?? '';
      _lastNameController.text = profileState.profile?.lastName ?? '';
      _phoneController.text = profileState.profile?.phoneNumber ?? '';
      _dateOfBirthController.text = profileState.profile?.dateOfBirth ?? '';
      _bloodGroupController.text = profileState.profile?.bloodGroup ?? '';
      _genderController.text = profileState.profile?.gender ?? '';
      _addressController.text = profileState.profile?.address ?? '';
    }

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: profileState.status == ProfileStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 32 : 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture Selector
                    const ImageSelectorWidget(),

                    SizedBox(height: isTablet ? 40 : 32),

                    // First Name Field
                    TextFormField(
                      controller: _firstNameController,
                      decoration: buildInputDecoration(
                        label: 'First Name',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Last Name Field
                    TextFormField(
                      controller: _lastNameController,
                      decoration: buildInputDecoration(
                        label: 'Last Name',
                        icon: Icons.person,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      decoration: buildInputDecoration(
                        label: 'Phone Number',
                        icon: Icons.phone,
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Date of Birth Field
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: buildInputDecoration(
                        label: 'Date of Birth',
                        icon: Icons.cake,
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 6570)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          _dateOfBirthController.text =
                              '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                        }
                      },
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Blood Group Field
                    DropdownButtonFormField<String>(
                      value: _bloodGroupController.text.isEmpty
                          ? null
                          : _bloodGroupController.text,
                      decoration: buildInputDecoration(
                        label: 'Blood Group',
                        icon: Icons.bloodtype,
                      ),
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                          .map((group) => DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _bloodGroupController.text = value;
                        }
                      },
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Gender Field
                    DropdownButtonFormField<String>(
                      value:
                          _genderController.text.isEmpty ? null : _genderController.text,
                      decoration: buildInputDecoration(
                        label: 'Gender',
                        icon: Icons.wc,
                      ),
                      items: const ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _genderController.text = value;
                        }
                      },
                    ),

                    SizedBox(height: isTablet ? 24 : 16),

                    // Address Field
                    TextFormField(
                      controller: _addressController,
                      decoration: buildInputDecoration(
                        label: 'Address',
                        icon: Icons.location_on,
                      ),
                      maxLines: 2,
                    ),

                    SizedBox(height: isTablet ? 40 : 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: profileState.status == ProfileStatus.updating
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref
                                      .read(profileViewModelProvider.notifier)
                                      .updateProfile(
                                        firstName:
                                            _firstNameController.text.trim(),
                                        lastName:
                                            _lastNameController.text.trim(),
                                        phoneNumber:
                                            _phoneController.text.trim(),
                                        dateOfBirth:
                                            _dateOfBirthController.text.trim(),
                                        bloodGroup:
                                            _bloodGroupController.text.trim(),
                                        gender: _genderController.text.trim(),
                                        address: _addressController.text.trim(),
                                      );
                                }
                              },
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 20 : 14),
                          child: profileState.status == ProfileStatus.updating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style:
                                      TextStyle(fontSize: isTablet ? 18 : 16),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
