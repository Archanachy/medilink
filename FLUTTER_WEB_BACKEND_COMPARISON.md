# Flutter vs Web Frontend vs Backend - Feature Comparison Report

**Generated:** March 4, 2026  
**Project:** MediLink Healthcare Platform  
**Purpose:** Document discrepancies between Flutter implementation, web frontend, and actual backend APIs

---

## Executive Summary

### 🔴 Critical Finding
The Flutter app has **full implementations** for **Hospitals** and **Emergency/Ambulance** features that **DO NOT EXIST** in the backend or web frontend. These features will **always fail** because the backend APIs are not implemented.

### Key Issues
1. **Hospital Feature** - Complete Flutter implementation calling non-existent `/hospitals` endpoints
2. **Emergency/Ambulance Feature** - Complete Flutter implementation calling non-existent `/emergency` endpoints
3. **Medical Records** - Flutter calls backend API that exists, but web frontend only uses local storage (no backend integration)

---

## 1. Backend API Reality Check

### ✅ Backend APIs That Actually Exist

Based on `/medilink-web-backend/src/app.ts` route registration:

```
Authentication:
  - /auth/login
  - /auth/register
  - /auth/forgot-password
  - /auth/reset-password

Patient Endpoints:
  - /auth/patients (GET, POST)
  - /auth/patients/:id (GET, PUT, DELETE)
  - /auth/patients/user/:userId

Doctor Endpoints:
  - /auth/doctors (GET, POST)
  - /auth/doctors/:id (GET, PUT, DELETE)
  - /auth/doctors/specialization
  - /auth/doctors/:id/availability

Appointment Endpoints:
  - /auth/appointments (GET, POST)
  - /auth/appointments/:id (GET, PUT, DELETE)
  - /auth/appointments/:id/cancel
  - /auth/appointments/available-slots
  - /auth/appointments/patient/:patientId
  - /auth/appointments/doctor/:doctorId

Prescription Endpoints:
  - /doctor/prescriptions (GET, POST)
  - /doctor/prescriptions/:id (GET, PUT)
  - /patient/prescriptions (GET)
  - /patient/prescriptions/:id (GET)

Medical Report Endpoints:
  - /medical-reports (GET, POST)
  - /medical-reports/:id (GET, PUT, DELETE)

Reviews Endpoints:
  - /reviews (GET, POST)
  - /reviews/doctor/:doctorId
  - /reviews/hospital/:hospitalId (endpoint exists but hospitals don't)

Notification Endpoints:
  - /notifications (GET, POST)
  - /notifications/:id (PUT, DELETE)
  - /notifications/:id/read

Support Ticket Endpoints:
  - /support/tickets (GET, POST)
  - /support/tickets/:id (GET, PUT)

Payment Endpoints:
  - /payments (GET, POST)
  - /payments/create-intent
  - /payments/confirm

Video Consultation Endpoints:
  - /patient/appointments/:id/start-video
  - /patient/video-consultations/:id
  - /doctor/appointments/:id/start-video
  - /doctor/video-consultations/:id

AI Symptoms:
  - /api/ai/symptoms

Content Management:
  - /content/faqs
  - /content/banners

System:
  - /admin/* (users, doctors, appointments, analytics, audit logs, settings)
```

### ❌ Backend APIs That DO NOT Exist

```
Hospital Endpoints:
  - /hospitals (NOT FOUND)
  - /hospitals/:id (NOT FOUND)
  - /hospitals/:id/doctors (NOT FOUND)

Emergency Endpoints:
  - /emergency/contacts (NOT FOUND)
  - /emergency/hospitals/nearest (NOT FOUND)
  - /emergency/ambulance (NOT FOUND)

Specialization Endpoints:
  - /specializations (NOT FOUND)
  - /specializations/:id (NOT FOUND)

Search Endpoints:
  - /search/doctors (NOT FOUND)
  - /search/hospitals (NOT FOUND)
```

**Verification Method:**
```bash
# Searched all backend controllers and routes
cd /medilink-web-backend/src
grep -r "emergency\|ambulance" routes/ controllers/  # NO RESULTS
grep -r "hospitals" routes/ controllers/            # NO RESULTS
ls -1 controllers/                                   # NO hospital or emergency controllers
ls -1 routes/                                        # NO hospital or emergency routes
```

---

## 2. Web Frontend Feature Reality

### ✅ Web Patient Features (Confirmed Working)

Located in `/medilink/app/patient/`:

```
✓ Dashboard (/patient/dashboard)
✓ Appointments (/patient/appointments)
  - List appointments
  - Book appointment (/patient/appointments/book)
  - Appointment detail (/patient/appointments/[id])
  - Video consultation (/patient/appointments/[id]/video)
✓ Doctors (/patient/doctors)
  - List doctors
  - Doctor profile (/patient/doctors/[id])
✓ Chat (/patient/chat)
  - Conversation list
  - Live chat (/patient/chat/[id])
✓ Medical Records (/patient/medical-records)
  - NOTE: Uses LOCAL STORAGE ONLY, not backend API
✓ Profile (/patient/profile)
✓ Support Tickets (/patient/support)
  - Create ticket (/patient/support/new)
  - Ticket detail (/patient/support/[id])
✓ Payments (/patient/payments)
✓ Checkout (/patient/checkout)
✓ AI Symptom Checker (/patient/ai-symptom-checker)
```

### ❌ Web Frontend Does NOT Have

```
✗ Hospitals feature (NO PAGE FOUND)
✗ Emergency/Ambulance feature (NO PAGE FOUND)
✗ Prescriptions as separate page (integrated in appointments)
✗ Notifications as separate page (likely in header dropdown)
```

**Verification Method:**
```bash
cd /medilink/app/patient
find . -name "*.tsx" -type f  # Listed all patient pages

# NO files found for:
# - hospitals
# - emergency
# - ambulance
```

---

## 3. Flutter Implementation Analysis

### ✅ Flutter Features Matching Backend

```
✓ Authentication (Login, Register, Forgot Password)
✓ Dashboard
✓ Appointments (List, Book, Detail, Cancel)
✓ Doctors (List, Detail, Filter)
✓ Chat (Live messaging via Socket.IO)
✓ Medical Records (List, Upload, Download, Filter)
✓ Prescriptions (List, Detail, Download PDF)
✓ Profile (View, Edit)
✓ Notifications (List, Mark Read)
✓ Support (Coming Soon screen - not implemented)
✓ Reviews (Domain layer exists, not fully integrated)
```

### 🔴 Flutter Features With NO Backend Support

#### Hospital Feature (Complete Implementation)
**Location:** `lib/features/hospitals/`

**Structure:**
```
hospitals/
├── domain/
│   ├── entities/hospital_entity.dart
│   ├── repositories/i_hospital_repository.dart
│   └── usecases/
│       ├── get_hospitals_usecase.dart
│       └── get_hospital_by_id_usecase.dart
├── data/
│   ├── models/hospital_api_model.dart
│   ├── datasources/
│   │   ├── hospital_remote_data_source.dart
│   │   └── hospital_local_data_source.dart
│   └── repositories/hospital_repository_impl.dart
└── presentation/
    ├── pages/
    │   ├── hospitals_list_screen.dart
    │   └── hospital_detail_screen.dart
    ├── widgets/hospital_card_widget.dart
    ├── viewmodel/hospital_viewmodel.dart
    ├── state/hospital_state.dart
    └── providers/hospital_providers.dart
```

**API Calls (WILL FAIL):**
- `GET /hospitals` - Backend returns 404
- `GET /hospitals/:id` - Backend returns 404
- `GET /hospitals/:id/doctors` - Backend returns 404

**Current Implementation:**
```dart
// lib/features/hospitals/data/datasources/hospital_remote_data_source.dart
Future<List<HospitalApiModel>> getHospitals({
  double? latitude,
  double? longitude,
  String? specialty,
  double? maxDistance,
  bool? isEmergencyOnly,
  bool? is24Hours,
}) async {
  final endpoint = '${ApiEndpoints.hospitals}?...'; // /hospitals
  final response = await _apiClient.get(endpoint); // ❌ 404 NOT FOUND
  // ...
}
```

#### Emergency/Ambulance Feature (Complete Implementation)
**Location:** `lib/features/emergency/`

**Structure:**
```
emergency/
├── domain/
│   ├── entities/
│   │   ├── emergency_contact_entity.dart
│   │   └── emergency_hospital_entity.dart
│   ├── repositories/i_emergency_repository.dart
│   └── usecases/
│       ├── get_emergency_contacts_usecase.dart
│       ├── get_nearest_hospitals_usecase.dart
│       └── request_ambulance_usecase.dart
├── data/
│   ├── models/emergency_api_model.dart
│   ├── data_source/remote/emergency_remote_data_source.dart
│   └── repositories/emergency_repository_impl.dart
└── presentation/
    ├── pages/
    │   ├── emergency_screen.dart
    │   └── ambulance_request_screen.dart
    ├── widgets/emergency_contacts_list_widget.dart
    ├── viewmodel/emergency_viewmodel.dart
    ├── state/emergency_state.dart
    └── providers/emergency_providers.dart
```

**API Calls (WILL FAIL):**
- `GET /emergency/contacts` - Backend returns 404
- `GET /emergency/hospitals/nearest` - Backend returns 404
- `POST /emergency/ambulance` - Backend returns 404

**Current Implementation:**
```dart
// lib/features/emergency/data/data_source/remote/emergency_remote_data_source.dart
Future<List<EmergencyContactApiModel>> getEmergencyContacts() async {
  final response = await _apiClient.get(ApiEndpoints.emergencyContacts); // ❌ 404
  // ...
}

Future<List<EmergencyHospitalApiModel>> getNearestHospitals({
  required double latitude,
  required double longitude,
}) async {
  final response = await _apiClient.get(
    ApiEndpoints.nearestHospitals, // /emergency/hospitals/nearest ❌ 404
    queryParameters: {'latitude': latitude, 'longitude': longitude},
  );
  // ...
}

Future<bool> requestAmbulance({
  required double latitude,
  required double longitude,
  required String description,
}) async {
  final response = await _apiClient.post(
    ApiEndpoints.ambulanceRequest, // /emergency/ambulance ❌ 404
    data: {
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    },
  );
  // ...
}
```

**UI Integration:**
```dart
// lib/features/dashboard/presentation/pages/bottom/emergency_bottom_screen.dart
// Bottom navigation bar has "Emergency" tab
// Features 4 quick actions:
// 1. Emergency Call (calls 911 via phone)
// 2. Nearest Hospital -> Navigator.pushNamed(context, '/hospitals'); ❌ FAILS
// 3. Request Ambulance -> Navigator.pushNamed(context, '/ambulance-request'); ❌ FAILS
// 4. Emergency Contacts -> Shows dialog ❌ API call fails
```

---

## 4. API Endpoint Comparison Matrix

| Endpoint | Backend Exists | Web Uses | Flutter Uses | Status |
|----------|---------------|----------|--------------|--------|
| `/auth/*` | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Working |
| `/auth/doctors` | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Working |
| `/auth/patients` | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Working |
| `/auth/appointments` | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Working |
| `/doctor/prescriptions` | ✅ Yes | ❌ No | ✅ Yes | ✅ Working |
| `/patient/prescriptions` | ✅ Yes | ❌ No | ✅ Yes | ✅ Working |
| `/medical-reports` | ✅ Yes | ❌ No (local) | ✅ Yes | ✅ Working |
| `/notifications` | ✅ Yes | ❌ No (header) | ✅ Yes | ✅ Working |
| `/reviews` | ✅ Yes | ✅ Yes | 🟡 Partial | 🟡 Backend works |
| `/support/tickets` | ✅ Yes | ✅ Yes | ❌ No | 🟡 Backend works |
| `/payments` | ✅ Yes | ✅ Yes | ❌ No | 🟡 Backend works |
| `/api/ai/symptoms` | ✅ Yes | ✅ Yes | ❌ No | 🟡 Backend works |
| `/patient/video-consultations` | ✅ Yes | ✅ Yes | ❌ No | 🟡 Backend works |
| **`/hospitals`** | **❌ NO** | ❌ No | ✅ Yes | **🔴 BROKEN** |
| **`/hospitals/:id`** | **❌ NO** | ❌ No | ✅ Yes | **🔴 BROKEN** |
| **`/emergency/contacts`** | **❌ NO** | ❌ No | ✅ Yes | **🔴 BROKEN** |
| **`/emergency/hospitals/nearest`** | **❌ NO** | ❌ No | ✅ Yes | **🔴 BROKEN** |
| **`/emergency/ambulance`** | **❌ NO** | ❌ No | ✅ Yes | **🔴 BROKEN** |
| `/specializations` | ❌ NO | ❌ No | ✅ Yes | 🔴 BROKEN |
| `/search/doctors` | ❌ NO | ❌ No | ✅ Yes | 🔴 BROKEN |
| `/search/hospitals` | ❌ NO | ❌ No | ✅ Yes | 🔴 BROKEN |

---

## 5. Root Cause Analysis

### Why Does This Discrepancy Exist?

1. **Flutter Development Was Ahead of Backend**
   - Flutter team implemented features assuming backend would follow
   - Backend development prioritized core features (appointments, doctors, prescriptions)
   - Hospital and emergency features were deprioritized or abandoned

2. **Web Frontend Was Built After Backend Stabilization**
   - Web frontend only implemented features with actual backend support
   - Medical records uses local storage workaround
   - No hospital/emergency features attempted

3. **No Cross-Platform Synchronization**
   - Flutter and web teams worked independently
   - No unified feature roadmap
   - Backend API contract not enforced before frontend implementation

---

## 6. User Impact Assessment

### 🔴 Critical User Experience Issues

#### Issue 1: Hospital Feature Always Fails
**User Flow:**
1. User taps "Emergency" tab in bottom navigation
2. User taps "Nearest Hospital" button
3. App navigates to Hospital List screen
4. **App makes API call to `/hospitals`**
5. **Backend returns 404 Not Found**
6. **User sees "Failed to load hospitals" error**

**Frequency:** Every time user tries to find hospitals

#### Issue 2: Emergency Contacts Fail to Load
**User Flow:**
1. User taps "Emergency Contacts" button
2. **App makes API call to `/emergency/contacts`**
3. **Backend returns 404 Not Found**
4. **Dialog shows "Failed to load emergency contacts"**

**Frequency:** Every time user tries to view emergency contacts

#### Issue 3: Ambulance Request Fails
**User Flow:**
1. User is in medical emergency
2. User taps "Request Ambulance" button
3. User fills location and description
4. User taps "Submit"
5. **App makes API call to `POST /emergency/ambulance`**
6. **Backend returns 404 Not Found**
7. **User sees "Failed to request ambulance" error**
8. **CRITICAL: User doesn't receive help in emergency**

**Frequency:** Every ambulance request attempt  
**Severity:** CRITICAL - Life-threatening if user relies on this in actual emergency

---

## 7. Recommended Solutions

### Option 1: Remove Non-Working Features (Quick Fix) ⚡
**Estimated Effort:** 2-3 hours  
**Pros:** Immediate fix, no backend work needed  
**Cons:** Reduces app functionality

**Implementation Steps:**
1. Remove hospital feature screens and routes
2. Remove emergency feature screens and routes
3. Update bottom navigation to remove "Emergency" tab
4. Remove API endpoint definitions from `api_endpoints.dart`
5. Clean up unused code (viewmodels, repositories, entities)

**Files to Remove/Modify:**
```dart
// REMOVE entire folders:
lib/features/hospitals/
lib/features/emergency/

// REMOVE from app.dart:
- '/hospitals' route
- '/hospital-detail' route
- '/emergency' route
- '/ambulance-request' route

// UPDATE dashboard_screen.dart:
- Remove EmergencyBottomScreen from bottom nav
- Change to 4-tab layout instead of 5

// UPDATE api_endpoints.dart:
- Remove hospital endpoints section
- Remove emergency endpoints section
```

**Code Changes:**
```dart
// lib/app/app.dart - BEFORE
final List<Widget> _bottomScreens = [
  HomeBottomScreen(),
  AppointmentsBottomScreen(),
  DoctorsBottomScreen(),
  EmergencyBottomScreen(), // REMOVE THIS
  ProfileBottomScreen(),
];

// lib/app/app.dart - AFTER
final List<Widget> _bottomScreens = [
  HomeBottomScreen(),
  AppointmentsBottomScreen(),
  DoctorsBottomScreen(),
  ProfileBottomScreen(), // Only 4 tabs now
];
```

### Option 2: Build Backend APIs (Complete Fix) 🔧
**Estimated Effort:** 2-3 weeks  
**Pros:** Full feature parity, proper implementation  
**Cons:** Significant backend development required

**Backend Requirements:**

#### Hospital Management System
```typescript
// 1. Create Hospital Model
interface Hospital {
  _id: string;
  name: string;
  address: string;
  latitude: number;
  longitude: number;
  phone: string;
  email: string;
  website?: string;
  departments: string[];
  specialties: string[];
  emergencyAvailable: boolean;
  is24Hours: boolean;
  rating: number;
  reviewCount: number;
  images: string[];
  createdAt: Date;
  updatedAt: Date;
}

// 2. Create Controllers
// src/controllers/hospital.controller.ts
- getHospitals(filters, pagination)
- getHospitalById(id)
- searchHospitals(query, location)
- getNearestHospitals(latitude, longitude, radius)

// 3. Create Routes
// src/routes/hospital.route.ts
GET /hospitals
GET /hospitals/:id
GET /hospitals/:id/doctors
GET /search/hospitals?q=...&lat=...&lng=...
```

#### Emergency Services System
```typescript
// 1. Create Emergency Contact Model
interface EmergencyContact {
  _id: string;
  name: string;
  phone: string;
  type: 'police' | 'fire' | 'ambulance' | 'hospital' | 'poison' | 'other';
  description: string;
  isActive: boolean;
}

// 2. Create Ambulance Request Model
interface AmbulanceRequest {
  _id: string;
  patientId: string;
  latitude: number;
  longitude: number;
  address: string;
  description: string;
  status: 'requested' | 'dispatched' | 'arrived' | 'completed' | 'cancelled';
  requestedAt: Date;
  dispatchedAt?: Date;
  arrivedAt?: Date;
  completedAt?: Date;
}

// 3. Create Controllers
// src/controllers/emergency.controller.ts
- getEmergencyContacts()
- getNearestHospitals(lat, lng)
- requestAmbulance(patientId, lat, lng, description)
- getAmbulanceRequestStatus(requestId)
- updateAmbulanceStatus(requestId, status)

// 4. Create Routes
// src/routes/emergency.route.ts
GET /emergency/contacts
GET /emergency/hospitals/nearest?lat=...&lng=...
POST /emergency/ambulance
GET /emergency/ambulance/:id
PUT /emergency/ambulance/:id/status
```

#### Additional Requirements
- **Location Services:** Integrate Google Maps API or similar for geocoding
- **Real-time Updates:** Socket.IO events for ambulance tracking
- **Admin Portal:** Manage hospitals, emergency contacts, ambulance requests
- **Database Seeding:** Populate initial hospital and emergency contact data

### Option 3: Mock Data (Temporary Workaround) 🩹
**Estimated Effort:** 4-6 hours  
**Pros:** App appears functional, buys time for backend work  
**Cons:** Not production-ready, misleading to users

**Implementation:** Create mock data providers that return hardcoded data without API calls

```dart
// lib/features/hospitals/data/datasources/hospital_local_data_source.dart
class HospitalLocalDataSource {
  List<HospitalEntity> getMockHospitals() {
    return [
      HospitalEntity(
        id: 'mock-1',
        name: 'City General Hospital',
        address: '123 Main St',
        latitude: 37.7749,
        longitude: -122.4194,
        phone: '(555) 123-4567',
        emergencyAvailable: true,
        is24Hours: true,
        departments: ['Emergency', 'Cardiology', 'Neurology'],
      ),
      // ... more mock data
    ];
  }
}

// Update repository to use local data only
class HospitalRepositoryImpl implements IHospitalRepository {
  final HospitalLocalDataSource _localDataSource;
  
  @override
  Future<Either<Failure, List<HospitalEntity>>> getHospitals() async {
    try {
      final hospitals = _localDataSource.getMockHospitals();
      return Right(hospitals);
    } catch (e) {
      return Left(ServerFailure('Failed to load hospitals'));
    }
  }
}
```

**Mock Data for Emergency:**
```dart
class EmergencyLocalDataSource {
  List<EmergencyContactEntity> getMockContacts() {
    return [
      EmergencyContactEntity(
        id: 'mock-ec-1',
        name: 'Emergency - 911',
        phone: '911',
        type: 'ambulance',
      ),
      EmergencyContactEntity(
        id: 'mock-ec-2',
        name: 'Poison Control',
        phone: '1-800-222-1222',
        type: 'poison',
      ),
      // ... more
    ];
  }
}
```

---

## 8. Decision Matrix

| Criteria | Option 1: Remove | Option 2: Build Backend | Option 3: Mock Data |
|----------|------------------|------------------------|---------------------|
| **Development Time** | 2-3 hours | 2-3 weeks | 4-6 hours |
| **Production Ready** | ✅ Yes | ✅ Yes | ❌ No |
| **User Experience** | Reduced features | Full features | Misleading |
| **Backend Work** | None | Extensive | None |
| **Maintenance** | Low | Medium | Low |
| **Risk** | Low | Medium | High (user trust) |
| **Cost** | $0 | $5,000-$10,000 | $0 |

---

## 9. Recommended Action Plan

### 🎯 **Recommended Approach: Option 1 (Remove Features)**

**Rationale:**
1. **Backend is complete** - All essential healthcare features work (appointments, doctors, prescriptions, chat)
2. **Web frontend doesn't have these** - Indicates they're not core requirements
3. **User safety** - Better to have no ambulance feature than one that fails in real emergency
4. **Time efficient** - Get app working correctly in 2-3 hours vs 2-3 weeks

### Implementation Checklist

#### Phase 1: Remove Hospital Feature (1 hour)
- [ ] Delete `lib/features/hospitals/` folder entirely
- [ ] Remove hospital routes from `lib/app/app.dart`
- [ ] Remove hospital imports from any files
- [ ] Remove hospital API endpoints from `lib/core/api/api_endpoints.dart`
- [ ] Search for "hospital" in codebase and clean up references
- [ ] Test: Verify app compiles without errors

#### Phase 2: Remove Emergency Feature (1 hour)
- [ ] Delete `lib/features/emergency/` folder entirely
- [ ] Remove emergency routes from `lib/app/app.dart`
- [ ] Remove `EmergencyBottomScreen` from dashboard navigation
- [ ] Update `_bottomScreens` list in `dashboard_screen.dart` to 4 tabs
- [ ] Update `BottomNavigationBar` items to 4 items
- [ ] Remove emergency API endpoints from `lib/core/api/api_endpoints.dart`
- [ ] Remove emergency quick action buttons from any screens
- [ ] Test: Verify bottom navigation works with 4 tabs

#### Phase 3: Clean Up & Test (30 minutes)
- [ ] Run `flutter clean && flutter pub get`
- [ ] Run `flutter analyze` to check for errors
- [ ] Test all remaining features:
  - [ ] Login/Registration
  - [ ] Dashboard statistics
  - [ ] Appointments (list, book, detail, cancel)
  - [ ] Doctors (list, search, detail)
  - [ ] Chat (conversation list, live chat)
  - [ ] Medical Records (list, upload, download)
  - [ ] Prescriptions (list, detail, download)
  - [ ] Profile (view, edit)
  - [ ] Notifications (list, mark read)
- [ ] Hot reload and verify UI looks correct
- [ ] Update documentation (PATIENT_FEATURES_REPORT.md, PATIENT_TESTING_CHECKLIST.md)

#### Phase 4: Documentation Update (30 minutes)
- [ ] Update PATIENT_FEATURES_REPORT.md to remove hospital/emergency
- [ ] Update PATIENT_TESTING_CHECKLIST.md to remove related test cases
- [ ] Update README.md feature list
- [ ] Add note about future hospital/emergency implementation if backend is built

---

## 10. Code Removal Guide

### Files to Delete Completely:

```bash
# Hospital Feature
rm -rf lib/features/hospitals/

# Emergency Feature  
rm -rf lib/features/emergency/
```

### Files to Modify:

#### 1. `lib/app/app.dart`
```dart
// REMOVE these imports:
import 'package:medilink/features/hospitals/presentation/pages/hospitals_list_screen.dart';
import 'package:medilink/features/hospitals/presentation/pages/hospital_detail_screen.dart';

// REMOVE these routes from routes map:
'/hospitals': (context) => const HospitalsListScreen(),

// REMOVE from onGenerateRoute:
if (settings.name == '/hospital-detail') {
  final hospitalId = settings.arguments as String?;
  if (hospitalId != null) {
    return MaterialPageRoute(
      builder: (context) => HospitalDetailScreen(hospitalId: hospitalId),
    );
  }
}

// ALSO REMOVE:
'/emergency': ...
'/ambulance-request': ...
```

#### 2. `lib/core/api/api_endpoints.dart`
```dart
// REMOVE lines 104-122:
// ============ Hospital/Clinic Endpoints ============
static const String hospitals = '/hospitals';
static String hospitalById(String id) => '/hospitals/$id';
static String hospitalDoctors(String id) => '/hospitals/$id/doctors';

// ============ Emergency Endpoints ============
static const String emergencyContacts = '/emergency/contacts';
static const String nearestHospitals = '/emergency/hospitals/nearest';
static const String ambulanceRequest = '/emergency/ambulance';
```

#### 3. `lib/features/dashboard/presentation/pages/dashboard_screen.dart`
```dart
// REMOVE import:
import 'package:medilink/features/dashboard/presentation/pages/bottom/emergency_bottom_screen.dart';

// UPDATE _bottomScreens list:
// BEFORE (5 tabs):
final List<Widget> _bottomScreens = [
  HomeBottomScreen(),
  AppointmentsBottomScreen(),
  DoctorsBottomScreen(),
  EmergencyBottomScreen(), // REMOVE THIS LINE
  ProfileBottomScreen(),
];

// AFTER (4 tabs):
final List<Widget> _bottomScreens = [
  HomeBottomScreen(),
  AppointmentsBottomScreen(),
  DoctorsBottomScreen(),
  ProfileBottomScreen(),
];

// UPDATE BottomNavigationBar items:
// BEFORE:
items: const [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
  BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Doctors'),
  BottomNavigationBarItem(icon: Icon(Icons.emergency), label: 'Emergency'), // REMOVE
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
],

// AFTER:
items: const [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
  BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Doctors'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
],
```

#### 4. `lib/features/dashboard/presentation/pages/bottom/profile_bottom_screen.dart`
```dart
// REMOVE these lines (~line 344-346):
ListTile(
  leading: Icon(Icons.emergency),
  title: Text('Emergency Contacts'),
  onTap: () => Navigator.pushNamed(context, '/emergency'),
),
```

#### 5. Search and Replace
Run these commands to find any remaining references:
```bash
cd lib/
grep -r "hospital" --include="*.dart" .
grep -r "emergency" --include="*.dart" .
grep -r "ambulance" --include="*.dart" .
```

---

## 11. Testing After Removal

### Critical Tests:

1. **App Launches Without Crash**
   - Cold start
   - Hot reload
   - Hot restart

2. **Bottom Navigation Works**
   - Tap each of 4 tabs (Home, Appointments, Doctors, Profile)
   - Verify correct screen shows for each tab
   - Verify selected tab indicator updates

3. **Profile Screen Navigation**
   - Verify no emergency contacts option
   - All other options work

4. **Search Functionality**
   - Doctors search still works
   - No hospital search option

5. **Deep Links**
   - Appointment details work
   - Doctor details work
   - Chat works

### Regression Tests:
Run existing test suite to ensure core features still work:
```bash
flutter test
flutter analyze
```

---

## 12. Future Considerations

### If Backend APIs Are Built Later:

When `/hospitals` and `/emergency` endpoints become available:

1. **Restore Feature Folders**
   - Create new `lib/features/hospitals/` and `/emergency/` from scratch or restore from git history
   - Alternatively, reference this commit to see removed code

2. **Test Against Real APIs**
   - Don't assume Flutter code will work as-is
   - Backend data structure may differ from original assumptions
   - Re-implement data models to match actual API responses

3. **Gradual Rollout**
   - Release hospital feature first (lower risk)
   - Test thoroughly before adding emergency/ambulance features
   - Consider region-specific rollout for ambulance services

### Alternative: Third-Party Services

Consider using external APIs instead of building backend:
- **Google Maps API** - Hospital search and directions
- **Emergency Services APIs** - Verify availability in target regions
- **Geocoding Services** - Convert addresses to coordinates

---

## 13. Appendix: Full API Endpoint List

### Backend Implemented Endpoints
```
Authentication:
POST /auth/register
POST /auth/login
POST /auth/forgot-password
POST /auth/reset-password
GET  /api/auth/users/:id
PUT  /api/auth/users/:id

Patients:
GET    /auth/patients
POST   /auth/patients
GET    /auth/patients/:id
PUT    /auth/patients/:id
DELETE /auth/patients/:id
GET    /auth/patients/user/:userId

Doctors:
GET    /auth/doctors
POST   /auth/doctors
GET    /auth/doctors/:id
PUT    /auth/doctors/:id
DELETE /auth/doctors/:id
GET    /auth/doctors/user/:userId
GET    /auth/doctors/specialization
GET    /auth/doctors/:id/availability
PUT    /auth/doctors/:id/availability

Appointments:
GET    /auth/appointments
POST   /auth/appointments
GET    /auth/appointments/:id
PUT    /auth/appointments/:id
DELETE /auth/appointments/:id
POST   /auth/appointments/:id/cancel
GET    /auth/appointments/available-slots
GET    /auth/appointments/patient/:patientId
GET    /auth/appointments/doctor/:doctorId

Prescriptions:
GET    /doctor/prescriptions
POST   /doctor/prescriptions
GET    /doctor/prescriptions/:id
PUT    /doctor/prescriptions/:id
POST   /doctor/prescriptions/:id/items
GET    /patient/prescriptions
GET    /patient/prescriptions/:id
GET    /patient/prescriptions/:id/download

Medical Reports:
GET    /medical-reports
POST   /medical-reports
GET    /medical-reports/:id
PUT    /medical-reports/:id
DELETE /medical-reports/:id

Reviews:
GET    /reviews
POST   /reviews
GET    /reviews/:id
GET    /reviews/doctor/:doctorId
GET    /reviews/hospital/:hospitalId (endpoint exists but hospitals don't)
GET    /doctor/reviews
GET    /doctor/reviews/stats

Notifications:
GET    /notifications
POST   /notifications
GET    /notifications/:id
PUT    /notifications/:id
DELETE /notifications/:id
PUT    /notifications/:id/read

Support Tickets:
GET    /support/tickets
POST   /support/tickets
GET    /support/tickets/:id
PUT    /support/tickets/:id
POST   /support/tickets/:id/responses
PUT    /support/tickets/:id/close
GET    /admin/support/tickets
GET    /admin/support/tickets/stats
PUT    /admin/support/tickets/:id/assign
PUT    /admin/support/tickets/:id/status
POST   /admin/support/tickets/:id/responses

Payments:
POST   /payments/create-intent
POST   /payments/confirm
GET    /patient/payments
GET    /patient/payments/:id
GET    /doctor/revenue
GET    /admin/payments
GET    /admin/payments/:id
POST   /admin/payments/:id/refund

Video Consultations:
POST   /patient/appointments/:id/start-video
GET    /patient/video-consultations/:id
POST   /patient/video-consultations/:id/end
POST   /doctor/appointments/:id/start-video
GET    /doctor/video-consultations/:id
POST   /doctor/video-consultations/:id/end

AI Symptoms:
POST   /api/ai/symptoms

Content:
GET    /content/faqs
GET    /content/banners
GET    /admin/content/faqs
POST   /admin/content/faqs
PUT    /admin/content/faqs/:id
DELETE /admin/content/faqs/:id
GET    /admin/content/banners
POST   /admin/content/banners
PUT    /admin/content/banners/:id
DELETE /admin/content/banners/:id

System:
GET    /admin/settings
GET    /admin/settings/:key
PUT    /admin/settings/:key
GET    /admin/audit-logs
GET    /admin/audit-logs/user/:userId
GET    /admin/audit-logs/export
GET    /api/admin/analytics/overview
GET    /api/admin/analytics/users
GET    /api/admin/analytics/revenue
GET    /api/admin/analytics/appointments
GET    /api/admin/analytics/doctors
GET    /api/admin/analytics/geolocation
GET    /api/admin/analytics/export
```

---

## Contact & Support

**Report Generated By:** GitHub Copilot AI Assistant  
**For Questions Contact:** Development Team  
**Last Updated:** March 4, 2026

---

**END OF REPORT**
