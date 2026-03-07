# Profile System Fixes - Doctor & Patient Role-Aware Implementation

## Summary
The Android profile system needs to be updated to match the web implementation with role-specific fields and functional navigation buttons.

## ✅ Completed
1. Added doctor-specific fields to `UserProfileEntity`:
   - specialization, qualifications, experience, consultationFee, bio, emergencyContact, role

## 🔧 Required Changes

### 1. Update UserProfileApiModel
**File:** `lib/features/edit_profile/data/models/user_profile_api_model.dart`

Add doctor/patient-specific fields to the model:
```dart
class UserProfileApiModel {
  // ... existing fields ...
  final String? role;
  final String? emergencyContact;
  // Doctor-specific
  final String? specialization;
  final String? qualifications;
  final String? experience;
  final double? consultationFee;
  final String? bio;
}
```

Update `fromJson` to handle these fields:
```dart
specialization: (userData['specialization'] as String?),
qualifications: (userData['qualifications'] as String?),
experience: (userData['experience'] as String?),
consultationFee: (userData['consultationFee'] as num?)?.toDouble(),
bio: (userData['bio'] as String?),
emergencyContact: (patientData['emergencyContact'] as String?),
role: (userData['role'] as String?),
```

### 2. Update Edit Profile Page to be Role-Aware
**File:** `lib/features/edit_profile/presentation/pages/edit_profile.dart`

**Current Issues:**
- Shows only patient fields (dateOfBirth, bloodGroup, gender)
- No doctor-specific fields
- Not role-aware

**Required Changes:**
1. Add role detection from `UserSessionService`
2. Show different fields based on role:

**Patient Fields:**
- firstName, lastName, phone
- dateOfBirth
- address
- emergencyContact

**Doctor Fields:**
- firstName, lastName, phone
- specialization
- qualifications
- experience (number input)
- consultationFee (number input)
- bio (multiline text)
- address

### 3. Update Profile View Model
**File:** `lib/features/edit_profile/presentation/view_model/profile_view_model.dart`

Add method signature to handle role-specific updates:
```dart
Future<void> updateProfilePatient({
  required String firstName,
  required String lastName,
  String? phoneNumber,
  String? dateOfBirth,
  String? address,
  String? emergencyContact,
});

Future<void> updateProfileDoctor({
  required String firstName,
  required String lastName,
  String? phoneNumber,
  String? specialization,
  String? qualifications,
  String? experience,
  String? consultationFee,
  String? bio,
  String? address,
});
```

### 4. Fix Profile Bottom Screen Buttons
**File:** `lib/features/dashboard/presentation/pages/bottom/profile_bottom_screen.dart`

**Current Issues:**
- Lines 326-358: Non-functional menu tiles with empty onTap or unimplemented routes
- Hardcoded medical reports data

**Required Fixes:**

**Option A - Remove Non-Functional Buttons:**
Remove these tiles until backend/pages are ready:
- My Reports (line 318)
- Medical History (line 320)
- Settings (line 321)
- My Prescriptions (line 325-328)
- Payments & Billing (line 329-332)
- Health Vitals (line 333-336)
- My Reviews (line 337-340)
- Favorite Doctors (line 341-344)
- Help & Support (line 346-349)
- Recent Reports card (lines 351-380)
- Upload New Report button (lines 381-385)

Keep only:
- Personal Information card
- Medical Information card (for patients)  
- Professional Information card (for doctors) - **NEW**
- Logout button

**Option B - Implement Navigation:**
Create placeholder screens for each route and implement navigation properly.

### 5. Make Profile Display Role-Aware
**File:** `lib/features/dashboard/presentation/pages/bottom/profile_bottom_screen.dart`

Replace "Medical Information" card with role-conditional display:

**For Patients:**
- Show: Blood Group, Gender, Allergies, Chronic Illnesses, Emergency Contact

**For Doctors:**
- Show: Professional Information card with:
  - Specialization
  - Qualifications
  - Experience
  - Consultation Fee
  - Bio

### 6. API Endpoint Updates
**File:** `lib/features/edit_profile/data/datasources/profile_remote_datasource.dart`

Ensure the update profile endpoint supports both patient and doctor fields:
```dart
// Current: PUT /auth/users/profile
// Should support both role-specific fields
```

## Implementation Priority

### P0 (Critical - Do First)
1. ✅ Update UserProfileEntity (DONE)
2. Update UserProfileApiModel with doctor/patient fields
3. Add role detection to Edit Profile page
4. Show correct fields based on role in Edit Profile

### P1 (High Priority)
5. Remove non-functional buttons from Profile Bottom Screen
6. Add Professional Information card for doctors
7. Update profile view model update methods

### P2 (Nice to Have)
8. Implement placeholder screens for removed features
9. Add profile picture upload functionality

## Web vs Android Field Mapping

### Patient Profile
| Web Field | Android Field | Status |
|-----------|---------------|--------|
| firstName | firstName | ✅ Exists |
| lastName | lastName | ✅ Exists |
| phone | phoneNumber | ✅ Exists |
| dateOfBirth | dateOfBirth | ✅ Exists |
| address | address | ✅ Exists |
| emergencyContact | emergencyContact | ✅ Added to entity |

### Doctor Profile
| Web Field | Android Field | Status |
|-----------|---------------|--------|
| firstName | firstName | ✅ Exists |
| lastName | lastName | ✅ Exists |
| phone | phoneNumber | ✅ Exists |
| specialization | specialization | ✅ Added to entity |
| qualifications | qualifications | ✅ Added to entity |
| experience | experience | ✅ Added to entity |
| consultationFee | consultationFee | ✅ Added to entity |
| bio | bio | ✅ Added to entity |
| address | address | ✅ Exists |

## Testing Checklist

### As Patient
- [ ] Profile loads with patient fields
- [ ] Edit profile shows: firstName, lastName, phone, dateOfBirth, address, emergencyContact
- [ ] Can save profile successfully
- [ ] Profile bottom screen shows medical information
- [ ] No doctor-specific fields visible

### As Doctor
- [ ] Profile loads with doctor fields
- [ ] Edit profile shows: firstName, lastName, phone, specialization, qualifications, experience, consultationFee, bio, address
- [ ] Can save profile successfully
- [ ] Profile bottom screen shows professional information
- [ ] No patient-specific medical fields visible

## Next Steps
Would you like me to:
1. **Implement all P0 changes now** (update API model, make edit profile role-aware)
2. **Remove non-functional buttons** from profile screen
3. **Both 1 and 2**

Please confirm and I'll proceed with the implementation.
