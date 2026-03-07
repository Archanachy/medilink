# MediLink Flutter Implementation Report
## Full Synchronization with medilink-web-backend

**Date:** February 26, 2026  
**Project:** MediLink Mobile (Flutter)  
**Backend:** medilink-web-backend  
**Architecture:** Clean Architecture

---

## Table of Contents
1. [Current State Analysis](#current-state-analysis)
2. [Backend API Mapping](#backend-api-mapping)
3. [Clean Architecture Implementation Strategy](#clean-architecture-implementation-strategy)
4. [Feature-by-Feature Implementation Guide](#feature-by-feature-implementation-guide)
5. [Data Synchronization Strategy](#data-synchronization-strategy)
6. [Testing Strategy](#testing-strategy)
7. [Deployment Checklist](#deployment-checklist)

---

## 1. Current State Analysis

### 1.1 Existing Implementation

#### ✅ **Completed Features**
- **Authentication Module**
  - Domain: Entities, Repository Interfaces, Use Cases
  - Data: API Models, Local Models (Hive), Data Sources, Repository Implementation
  - Presentation: Login/Signup Screens, ViewModels, States
  - Status: ~80% Complete

- **Profile Module**
  - Domain: User Profile & Patient Entities, Use Cases
  - Data: API Models, Remote Data Sources
  - Presentation: Profile View, Edit Profile
  - Status: ~70% Complete

- **Dashboard Module**
  - Presentation: Bottom Navigation (Home, Appointments, Records, Profile)
  - Status: ~40% Complete (UI Only)

- **Core Infrastructure**
  - API Client (Dio) with interceptors
  - Network connectivity check
  - Hive local database
  - Secure storage for tokens
  - Riverpod state management

#### ⚠️ **Partially Implemented**
- Basic UI screens without backend integration
- Offline-first approach setup but incomplete
- Error handling framework in place

#### ❌ **Missing Features**
- Appointments Management
- Medical Records
- Doctor Search & Listings
- Real-time Chat
- Notifications
- File Upload/Download (Medical Reports)
- WebSocket integration
- Background sync
- Comprehensive error handling

### 1.2 Current Backend Configuration

```dart
// Current Base URL
static const String baseUrl = 'http://10.0.2.2:5050/auth';

// Endpoints Defined
- /login               [POST]  User login
- /register            [POST]  User registration
- /users/:id           [GET]   Get user by ID
- /users/:id           [PUT]   Update user
- /users/:id/photo     [PUT]   Upload user photo
- /patients/:id        [GET]   Get patient by ID
- /patients/:id        [PUT]   Update patient
- /patients/user/:id   [GET]   Get patient by user ID
```

**Configuration Needed:**
- Production base URL
- Proper environment variables
- API versioning

---

## 2. Backend API Mapping

### 2.1 Expected Backend Architecture

Based on typical medilink-web-backend structure, we expect:

```
medilink-web-backend/
├── src/
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── user.controller.js
│   │   ├── patient.controller.js
│   │   ├── doctor.controller.js
│   │   ├── appointment.controller.js
│   │   ├── medical-record.controller.js
│   │   └── notification.controller.js
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   └── services/
├── .env
└── server.js
```

### 2.2 Complete API Endpoint Mapping

#### **Authentication Endpoints** ✅
```
Base: /auth

POST   /auth/register              - Register new user
POST   /auth/login                 - User login
POST   /auth/logout                - User logout
POST   /auth/refresh-token         - Refresh JWT token
POST   /auth/forgot-password       - Initiate password reset
POST   /auth/reset-password        - Complete password reset
POST   /auth/verify-email          - Verify email address
GET    /auth/me                    - Get current user
```

#### **User Endpoints** 🔄
```
Base: /users

GET    /users/:id                  - Get user by ID
PUT    /users/:id                  - Update user profile
DELETE /users/:id                  - Delete user account
PUT    /users/:id/photo            - Upload profile photo
GET    /users/:id/appointments     - Get user appointments
GET    /users/:id/records          - Get user medical records
```

#### **Patient Endpoints** 🔄
```
Base: /patients

POST   /patients                   - Create patient profile
GET    /patients/:id               - Get patient by ID
PUT    /patients/:id               - Update patient profile
DELETE /patients/:id               - Delete patient profile
GET    /patients/user/:userId      - Get patient by user ID
GET    /patients/:id/history       - Get medical history
POST   /patients/:id/records       - Add medical record
```

#### **Doctor Endpoints** ❌
```
Base: /doctors

GET    /doctors                    - List all doctors (with filters)
GET    /doctors/:id                - Get doctor details
GET    /doctors/:id/availability   - Get doctor availability
GET    /doctors/:id/reviews        - Get doctor reviews
GET    /doctors/specialization/:spec - Get doctors by specialization
POST   /doctors/:id/reviews        - Add doctor review
```

#### **Appointment Endpoints** ❌
```
Base: /appointments

POST   /appointments               - Book appointment
GET    /appointments/:id           - Get appointment details
PUT    /appointments/:id           - Update appointment
DELETE /appointments/:id           - Cancel appointment
GET    /appointments/user/:userId  - Get user's appointments
GET    /appointments/doctor/:docId - Get doctor's appointments
PUT    /appointments/:id/status    - Update appointment status
GET    /appointments/upcoming      - Get upcoming appointments
GET    /appointments/history       - Get appointment history
```

#### **Medical Records Endpoints** ❌
```
Base: /records

POST   /records                    - Upload medical record
GET    /records/:id                - Get record details
PUT    /records/:id                - Update record
DELETE /records/:id                - Delete record
GET    /records/patient/:patientId - Get patient records
POST   /records/:id/files          - Upload record files
GET    /records/:id/files          - Download record files
```

#### **Notification Endpoints** ❌
```
Base: /notifications

GET    /notifications              - Get user notifications
PUT    /notifications/:id/read     - Mark as read
DELETE /notifications/:id          - Delete notification
POST   /notifications/settings     - Update notification preferences
```

#### **Chat/Messaging Endpoints** ❌
```
Base: /messages

GET    /messages/conversations     - Get user conversations
GET    /messages/:conversationId   - Get conversation messages
POST   /messages                   - Send message
WebSocket /ws/chat                 - Real-time chat connection
```

#### **Search Endpoints** ❌
```
Base: /search

GET    /search/doctors             - Search doctors
GET    /search/specializations     - Search specializations
GET    /search/hospitals           - Search hospitals
```

---

## 3. Clean Architecture Implementation Strategy

### 3.1 Layer-by-Layer Development Approach

#### **Phase 1: Domain Layer First** (Foundation)
For each feature, always start here:

```
lib/features/{feature_name}/domain/
├── entities/              # Pure Dart business objects
│   └── {feature}_entity.dart
├── repositories/          # Abstract contracts
│   └── {feature}_repository.dart
└── usecases/              # Business logic
    ├── get_{feature}_usecase.dart
    ├── create_{feature}_usecase.dart
    ├── update_{feature}_usecase.dart
    └── delete_{feature}_usecase.dart
```

**Rules:**
- ✅ NO Flutter dependencies
- ✅ NO external package dependencies (except Equatable, Dartz)
- ✅ Pure Dart only
- ✅ Testable without framework

#### **Phase 2: Data Layer** (Infrastructure)
Implement after domain is complete:

```
lib/features/{feature_name}/data/
├── models/                # DTOs & Serialization
│   ├── {feature}_api_model.dart      # For backend
│   └── {feature}_local_model.dart    # For Hive
├── datasources/           # Data access
│   ├── {feature}_remote_datasource.dart
│   └── {feature}_local_datasource.dart
├── mappers/               # Model ↔ Entity conversion
│   └── {feature}_mapper.dart
└── repositories/          # Implementation
    └── {feature}_repository_impl.dart
```

**Rules:**
- ✅ Implements domain repository interfaces
- ✅ Handles JSON serialization
- ✅ Manages API calls & local storage
- ✅ Never exposes models to presentation

#### **Phase 3: Presentation Layer** (UI)
Build after data layer works:

```
lib/features/{feature_name}/presentation/
├── pages/                 # Screens
│   └── {feature}_screen.dart
├── widgets/               # Reusable UI components
│   └── {feature}_widgets.dart
├── view_models/           # Business logic + state
│   └── {feature}_view_model.dart
└── states/                # State definitions
    └── {feature}_state.dart
```

**Rules:**
- ✅ Never contains business logic
- ✅ Communicates through ViewModels
- ✅ Uses domain entities (not models)
- ✅ Handles only UI concerns

### 3.2 Dependency Injection Setup

Use Riverpod providers for DI:

```dart
// 1. Data Source Providers
final doctorRemoteDataSourceProvider = Provider<DoctorRemoteDataSource>((ref) {
  return DoctorRemoteDataSource(ref.read(apiClientProvider));
});

final doctorLocalDataSourceProvider = Provider<DoctorLocalDataSource>((ref) {
  return DoctorLocalDataSource();
});

// 2. Repository Providers
final doctorRepositoryProvider = Provider<IDoctorRepository>((ref) {
  return DoctorRepositoryImpl(
    remoteDatasource: ref.read(doctorRemoteDataSourceProvider),
    localDatasource: ref.read(doctorLocalDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

// 3. UseCase Providers
final getDoctorsUsecaseProvider = Provider<GetDoctorsUsecase>((ref) {
  return GetDoctorsUsecase(ref.read(doctorRepositoryProvider));
});

// 4. ViewModel Providers
final doctorViewModelProvider = 
    StateNotifierProvider<DoctorViewModel, DoctorState>((ref) {
  return DoctorViewModel(
    getDoctorsUsecase: ref.read(getDoctorsUsecaseProvider),
    // ... other usecases
  );
});
```

---

## 4. Feature-by-Feature Implementation Guide

### FEATURE 1: Authentication (Enhance Existing) 🔄

#### Current Status: 80% Complete

#### Missing Implementation:
1. Forgot Password
2. Reset Password
3. Email Verification
4. Token Refresh
5. Social Login (Google, Apple)

#### Step-by-Step Implementation:

##### **Step 1.1: Update Domain Layer**

**File:** `lib/features/auth/domain/entities/auth_entity.dart`
```dart
// Add new fields if needed
class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String userName;
  final String? password;
  final String? profilePicture;
  final bool isEmailVerified;  // NEW
  final String? role;           // NEW
  final DateTime? createdAt;    // NEW
  
  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userName,
    this.password,
    this.profilePicture,
    this.isEmailVerified = false,
    this.role,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    authId, fullName, email, phoneNumber, userName, 
    password, profilePicture, isEmailVerified, role, createdAt
  ];
}
```

**File:** `lib/features/auth/domain/repositories/auth_repository.dart`
```dart
abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
  
  // NEW METHODS
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword);
  Future<Either<Failure, bool>> verifyEmail(String token);
  Future<Either<Failure, String>> refreshToken(String refreshToken);
  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken);
  Future<Either<Failure, AuthEntity>> loginWithApple(String authorizationCode);
}
```

**New Use Cases:**

**File:** `lib/features/auth/domain/usecases/forgot_password_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams extends Equatable {
  final String email;
  const ForgotPasswordParams({required this.email});
  
  @override
  List<Object?> get props => [email];
}

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(ref.read(authRepositoryProvider));
});

class ForgotPasswordUsecase implements UsecaseWithParams<bool, ForgotPasswordParams> {
  final IAuthRepository _repository;
  
  ForgotPasswordUsecase(this._repository);
  
  @override
  Future<Either<Failure, bool>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(params.email);
  }
}
```

**File:** `lib/features/auth/domain/usecases/reset_password_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/auth/data/repositories/auth_repository.dart';
import 'package:medilink/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;
  
  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
  
  @override
  List<Object?> get props => [token, newPassword];
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(ref.read(authRepositoryProvider));
});

class ResetPasswordUsecase implements UsecaseWithParams<bool, ResetPasswordParams> {
  final IAuthRepository _repository;
  
  ResetPasswordUsecase(this._repository);
  
  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) {
    return _repository.resetPassword(params.token, params.newPassword);
  }
}
```

##### **Step 1.2: Update Data Layer**

**File:** `lib/core/api/api_endpoints.dart`
```dart
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - UPDATE THIS
  static const String baseUrl = 'http://10.0.2.2:5050';
  static const String authBase = '$baseUrl/auth';
  static const String apiBase = '$baseUrl/api/v1';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String refreshToken = '/auth/refresh-token';
  static const String me = '/auth/me';

  // ============ User Endpoints ============
  static String userById(String id) => '/users/$id';
  static String userPhoto(String id) => '/users/$id/photo';
  static String userAppointments(String id) => '/users/$id/appointments';
  static String userRecords(String id) => '/users/$id/records';

  // ============ Patient Endpoints ============
  static const String patients = '/patients';
  static String patientById(String id) => '/patients/$id';
  static String patientByUserId(String userId) => '/patients/user/$userId';
  static String patientHistory(String id) => '/patients/$id/history';
  static String patientRecords(String id) => '/patients/$id/records';

  // ============ Doctor Endpoints ============
  static const String doctors = '/doctors';
  static String doctorById(String id) => '/doctors/$id';
  static String doctorAvailability(String id) => '/doctors/$id/availability';
  static String doctorReviews(String id) => '/doctors/$id/reviews';
  static String doctorsBySpecialization(String spec) => '/doctors/specialization/$spec';

  // ============ Appointment Endpoints ============
  static const String appointments = '/appointments';
  static String appointmentById(String id) => '/appointments/$id';
  static String appointmentsByUser(String userId) => '/appointments/user/$userId';
  static String appointmentsByDoctor(String docId) => '/appointments/doctor/$docId';
  static String appointmentStatus(String id) => '/appointments/$id/status';
  static const String upcomingAppointments = '/appointments/upcoming';
  static const String appointmentHistory = '/appointments/history';

  // ============ Medical Records Endpoints ============
  static const String records = '/records';
  static String recordById(String id) => '/records/$id';
  static String recordsByPatient(String patientId) => '/records/patient/$patientId';
  static String recordFiles(String id) => '/records/$id/files';

  // ============ Notification Endpoints ============
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationSettings = '/notifications/settings';

  // ============ Chat Endpoints ============
  static const String conversations = '/messages/conversations';
  static String conversationMessages(String id) => '/messages/$id';
  static const String sendMessage = '/messages';
  static const String chatWebSocket = '/ws/chat';

  // ============ Search Endpoints ============
  static const String searchDoctors = '/search/doctors';
  static const String searchSpecializations = '/search/specializations';
  static const String searchHospitals = '/search/hospitals';
}
```

**File:** `lib/features/auth/data/models/auth_api_model.dart`
```dart
// UPDATE existing model
import 'package:medilink/features/auth/domain/enitities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? profilePicture;
  final bool isEmailVerified;  // NEW
  final String? role;           // NEW
  final DateTime? createdAt;    // NEW
  final String? token;          // NEW
  final String? refreshToken;   // NEW

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.password,
    this.profilePicture,
    this.isEmailVerified = false,
    this.role,
    this.createdAt,
    this.token,
    this.refreshToken,
  });

  String get userName => email.split('@')[0];

  Map<String, dynamic> toJson() {
    final names = fullName.split(' ');
    return {
      "firstName": names.isNotEmpty ? names[0] : "",
      "lastName": names.length > 1 ? names.sublist(1).join(' ') : "",
      "email": email,
      "phoneNumber": phoneNumber ?? "",
      "username": userName,
      "password": password,
      "profilePicture": profilePicture ?? "",
      "confirmPassword": password,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    return AuthApiModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      fullName: fullName.isEmpty ? (json['username'] as String? ?? '') : fullName,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      role: json['role'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      userName: userName,
      profilePicture: profilePicture,
      isEmailVerified: isEmailVerified,
      role: role,
      createdAt: createdAt,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      profilePicture: entity.profilePicture,
      isEmailVerified: entity.isEmailVerified,
      role: entity.role,
      createdAt: entity.createdAt,
    );
  }
}
```

**File:** `lib/features/auth/data/datasources/remote/auth_remote_datasource.dart`
```dart
// ADD new methods to existing class
class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  // ... existing code ...

  @override
  Future<bool> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    final response = await _apiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> verifyEmail(String token) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyEmail,
      data: {'token': token},
    );
    return response.data['success'] == true;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    
    if (response.data['success'] == true) {
      final newToken = response.data['data']['token'] as String;
      // Save new token to secure storage
      await const FlutterSecureStorage().write(key: 'auth_token', value: newToken);
      return newToken;
    }
    throw Exception('Token refresh failed');
  }

  @override
  Future<AuthApiModel?> loginWithGoogle(String idToken) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.authBase}/google',
      data: {'idToken': idToken},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);
      
      // Save token
      if (user.token != null) {
        await const FlutterSecureStorage().write(
          key: 'auth_token', 
          value: user.token!,
        );
      }

      // Save session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        userName: user.userName,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture ?? '',
      );

      return user;
    }
    return null;
  }
}
```

**File:** `lib/features/auth/data/repositories/auth_repository.dart`
```dart
// ADD implementations for new methods
class AuthRepository implements IAuthRepository {
  // ... existing code ...

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.forgotPassword(email);
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to send reset email',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String token, 
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.resetPassword(token, newPassword);
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Password reset failed',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmail(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.verifyEmail(token);
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Email verification failed',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final newToken = await _authRemoteDataSource.refreshToken(refreshToken);
      return Right(newToken);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle(String idToken) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.loginWithGoogle(idToken);
        if (apiModel != null) {
          return Right(apiModel.toEntity());
        }
        return const Left(ApiFailure(message: 'Google login failed'));
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Google login failed',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
```

##### **Step 1.3: Update Presentation Layer**

**Create New Screen:** `lib/features/auth/presentation/pages/forgot_password_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/auth/presentation/view_model/auth_view_model.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => 
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref.read(authViewModelProvider.notifier).forgotPassword(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleForgotPassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Update:** `lib/features/auth/presentation/view_model/auth_view_model.dart`
```dart
// Add new methods
class AuthViewModel extends Notifier<AuthState> {
  // ... existing code ...

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _forgotPasswordUsecase(
      ForgotPasswordParams(email: email),
    );
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> loginWithGoogle(String idToken) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _loginWithGoogleUsecase(
      LoginWithGoogleParams(idToken: idToken),
    );
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
        status: AuthStatus.authenticated,
      ),
    );
  }
}
```

---

### FEATURE 2: Doctor Management (New Feature) ❌

#### Implementation Steps:

##### **Step 2.1: Create Domain Layer**

**File:** `lib/features/doctors/domain/entities/doctor_entity.dart`
```dart
import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String specialization;
  final String? subspecialization;
  final String? qualification;
  final int experienceYears;
  final String? bio;
  final String? profilePicture;
  final double rating;
  final int reviewCount;
  final String? hospitalName;
  final String? hospitalAddress;
  final double consultationFee;
  final bool isAvailable;
  final List<String> availableDays;
  final String? startTime;
  final String? endTime;

  const DoctorEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.specialization,
    this.subspecialization,
    this.qualification,
    required this.experienceYears,
    this.bio,
    this.profilePicture,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.hospitalName,
    this.hospitalAddress,
    required this.consultationFee,
    this.isAvailable = true,
    this.availableDays = const [],
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [
    id, firstName, lastName, fullName, email, phoneNumber,
    specialization, subspecialization, qualification, experienceYears,
    bio, profilePicture, rating, reviewCount, hospitalName,
    hospitalAddress, consultationFee, isAvailable, availableDays,
    startTime, endTime,
  ];
}

class DoctorAvailabilityEntity extends Equatable {
  final String doctorId;
  final String date;
  final List<String> availableSlots;

  const DoctorAvailabilityEntity({
    required this.doctorId,
    required this.date,
    required this.availableSlots,
  });

  @override
  List<Object?> get props => [doctorId, date, availableSlots];
}

class DoctorReviewEntity extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  const DoctorReviewEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, doctorId, patientId, patientName, rating, comment, createdAt,
  ];
}
```

**File:** `lib/features/doctors/domain/repositories/doctor_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

abstract interface class IDoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  });
  
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id);
  
  Future<Either<Failure, DoctorAvailabilityEntity>> getDoctorAvailability(
    String doctorId,
    String date,
  );
  
  Future<Either<Failure, List<DoctorReviewEntity>>> getDoctorReviews(
    String doctorId,
  );
  
  Future<Either<Failure, bool>> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  );
  
  Future<Either<Failure, List<String>>> getSpecializations();
}
```

**File:** `lib/features/doctors/domain/usecases/get_doctors_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorsParams extends Equatable {
  final String? specialization;
  final String? searchQuery;
  final int? page;
  final int? limit;

  const GetDoctorsParams({
    this.specialization,
    this.searchQuery,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [specialization, searchQuery, page, limit];
}

final getDoctorsUsecaseProvider = Provider<GetDoctorsUsecase>((ref) {
  return GetDoctorsUsecase(ref.read(doctorRepositoryProvider));
});

class GetDoctorsUsecase implements UsecaseWithParams<List<DoctorEntity>, GetDoctorsParams> {
  final IDoctorRepository _repository;

  GetDoctorsUsecase(this._repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(GetDoctorsParams params) {
    return _repository.getDoctors(
      specialization: params.specialization,
      searchQuery: params.searchQuery,
      page: params.page,
      limit: params.limit,
    );
  }
}
```

**File:** `lib/features/doctors/domain/usecases/get_doctor_by_id_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorByIdParams extends Equatable {
  final String doctorId;

  const GetDoctorByIdParams({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

final getDoctorByIdUsecaseProvider = Provider<GetDoctorByIdUsecase>((ref) {
  return GetDoctorByIdUsecase(ref.read(doctorRepositoryProvider));
});

class GetDoctorByIdUsecase implements UsecaseWithParams<DoctorEntity, GetDoctorByIdParams> {
  final IDoctorRepository _repository;

  GetDoctorByIdUsecase(this._repository);

  @override
  Future<Either<Failure, DoctorEntity>> call(GetDoctorByIdParams params) {
    return _repository.getDoctorById(params.doctorId);
  }
}
```

##### **Step 2.2: Create Data Layer**

**File:** `lib/features/doctors/data/models/doctor_api_model.dart`
```dart
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

class DoctorApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String specialization;
  final String? subspecialization;
  final String? qualification;
  final int experienceYears;
  final String? bio;
  final String? profilePicture;
  final double rating;
  final int reviewCount;
  final String? hospitalName;
  final String? hospitalAddress;
  final double consultationFee;
  final bool isAvailable;
  final List<String> availableDays;
  final String? startTime;
  final String? endTime;

  DoctorApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.specialization,
    this.subspecialization,
    this.qualification,
    required this.experienceYears,
    this.bio,
    this.profilePicture,
    required this.rating,
    required this.reviewCount,
    this.hospitalName,
    this.hospitalAddress,
    required this.consultationFee,
    required this.isAvailable,
    required this.availableDays,
    this.startTime,
    this.endTime,
  });

  factory DoctorApiModel.fromJson(Map<String, dynamic> json) {
    return DoctorApiModel(
      id: json['_id'] as String? ?? json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      specialization: json['specialization'] as String,
      subspecialization: json['subspecialization'] as String?,
      qualification: json['qualification'] as String?,
      experienceYears: json['experienceYears'] as int? ?? 0,
      bio: json['bio'] as String?,
      profilePicture: json['profilePicture'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      hospitalName: json['hospitalName'] as String?,
      hospitalAddress: json['hospitalAddress'] as String?,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableDays: (json['availableDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'subspecialization': subspecialization,
      'qualification': qualification,
      'experienceYears': experienceYears,
      'bio': bio,
      'profilePicture': profilePicture,
      'rating': rating,
      'reviewCount': reviewCount,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  DoctorEntity toEntity() {
    return DoctorEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fullName: '$firstName $lastName',
      email: email,
      phoneNumber: phoneNumber,
      specialization: specialization,
      subspecialization: subspecialization,
      qualification: qualification,
      experienceYears: experienceYears,
      bio: bio,
      profilePicture: profilePicture,
      rating: rating,
      reviewCount: reviewCount,
      hospitalName: hospitalName,
      hospitalAddress: hospitalAddress,
      consultationFee: consultationFee,
      isAvailable: isAvailable,
      availableDays: availableDays,
      startTime: startTime,
      endTime: endTime,
    );
  }

  static List<DoctorEntity> toEntityList(List<DoctorApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
```

**File:** `lib/features/doctors/data/datasources/doctor_remote_datasource.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/features/doctors/data/models/doctor_api_model.dart';

final doctorRemoteDataSourceProvider = Provider<DoctorRemoteDataSource>((ref) {
  return DoctorRemoteDataSource(ref.read(apiClientProvider));
});

class DoctorRemoteDataSource {
  final ApiClient _apiClient;

  DoctorRemoteDataSource(this._apiClient);

  Future<List<DoctorApiModel>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (specialization != null) queryParams['specialization'] = specialization;
    if (searchQuery != null) queryParams['search'] = searchQuery;
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _apiClient.get(
      ApiEndpoints.doctors,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List;
    return data.map((json) => DoctorApiModel.fromJson(json)).toList();
  }

  Future<DoctorApiModel> getDoctorById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.doctorById(id));
    final data = response.data['data'];
    return DoctorApiModel.fromJson(data);
  }

  Future<Map<String, dynamic>> getDoctorAvailability(
    String doctorId,
    String date,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.doctorAvailability(doctorId),
      queryParameters: {'date': date},
    );
    return response.data['data'];
  }

  Future<List<Map<String, dynamic>>> getDoctorReviews(String doctorId) async {
    final response = await _apiClient.get(
      ApiEndpoints.doctorReviews(doctorId),
    );
    final data = response.data['data'] as List;
    return data.cast<Map<String, dynamic>>();
  }

  Future<bool> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.doctorReviews(doctorId),
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
    return response.data['success'] == true;
  }

  Future<List<String>> getSpecializations() async {
    final response = await _apiClient.get(
      ApiEndpoints.searchSpecializations,
    );
    final data = response.data['data'] as List;
    return data.map((e) => e['name'] as String).toList();
  }
}
```

**File:** `lib/features/doctors/data/repositories/doctor_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/features/doctors/data/datasources/doctor_remote_datasource.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';
import 'package:medilink/features/doctors/domain/repositories/doctor_repository.dart';

final doctorRepositoryProvider = Provider<IDoctorRepository>((ref) {
  return DoctorRepositoryImpl(
    remoteDataSource: ref.read(doctorRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class DoctorRepositoryImpl implements IDoctorRepository {
  final DoctorRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  DoctorRepositoryImpl({
    required DoctorRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? specialization,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getDoctors(
          specialization: specialization,
          searchQuery: searchQuery,
          page: page,
          limit: limit,
        );
        final entities = models.map((m) => m.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch doctors',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Return cached data or error
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getDoctorById(id);
        return Right(model.toEntity());
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch doctor',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, DoctorAvailabilityEntity>> getDoctorAvailability(
    String doctorId,
    String date,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final data = await _remoteDataSource.getDoctorAvailability(
          doctorId,
          date,
        );
        final entity = DoctorAvailabilityEntity(
          doctorId: doctorId,
          date: date,
          availableSlots: (data['availableSlots'] as List)
              .map((e) => e as String)
              .toList(),
        );
        return Right(entity);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch availability',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<DoctorReviewEntity>>> getDoctorReviews(
    String doctorId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final data = await _remoteDataSource.getDoctorReviews(doctorId);
        final entities = data.map((json) => DoctorReviewEntity(
          id: json['_id'] as String,
          doctorId: doctorId,
          patientId: json['patientId'] as String,
          patientName: json['patientName'] as String,
          rating: (json['rating'] as num).toDouble(),
          comment: json['comment'] as String?,
          createdAt: DateTime.parse(json['createdAt'] as String),
        )).toList();
        return Right(entities);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch reviews',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> addDoctorReview(
    String doctorId,
    double rating,
    String? comment,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.addDoctorReview(
          doctorId,
          rating,
          comment,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to add review',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSpecializations() async {
    if (await _networkInfo.isConnected) {
      try {
        final specializations = await _remoteDataSource.getSpecializations();
        return Right(specializations);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch specializations',
          statusCode: e.response?.statusCode,
        ));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
```

##### **Step 2.3: Create Presentation Layer**

**File:** `lib/features/doctors/presentation/states/doctor_state.dart`
```dart
import 'package:equatable/equatable.dart';
import 'package:medilink/features/doctors/domain/entities/doctor_entity.dart';

enum DoctorStatus { initial, loading, success, error }

class DoctorState extends Equatable {
  final DoctorStatus status;
  final List<DoctorEntity> doctors;
  final DoctorEntity? selectedDoctor;
  final List<String> specializations;
  final String? error;
  final bool isLoading;

  const DoctorState({
    this.status = DoctorStatus.initial,
    this.doctors = const [],
    this.selectedDoctor,
    this.specializations = const [],
    this.error,
    this.isLoading = false,
  });

  DoctorState copyWith({
    DoctorStatus? status,
    List<DoctorEntity>? doctors,
    DoctorEntity? selectedDoctor,
    List<String>? specializations,
    String? error,
    bool? isLoading,
  }) {
    return DoctorState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      specializations: specializations ?? this.specializations,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    status, doctors, selectedDoctor, specializations, error, isLoading,
  ];
}
```

**File:** `lib/features/doctors/presentation/view_model/doctor_view_model.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/doctors/domain/usecases/get_doctor_by_id_usecase.dart';
import 'package:medilink/features/doctors/domain/usecases/get_doctors_usecase.dart';
import 'package:medilink/features/doctors/presentation/states/doctor_state.dart';

final doctorViewModelProvider = 
    StateNotifierProvider<DoctorViewModel, DoctorState>((ref) {
  return DoctorViewModel(
    getDoctorsUsecase: ref.read(getDoctorsUsecaseProvider),
    getDoctorByIdUsecase: ref.read(getDoctorByIdUsecaseProvider),
  );
});

class DoctorViewModel extends StateNotifier<DoctorState> {
  final GetDoctorsUsecase _getDoctorsUsecase;
  final GetDoctorByIdUsecase _getDoctorByIdUsecase;

  DoctorViewModel({
    required GetDoctorsUsecase getDoctorsUsecase,
    required GetDoctorByIdUsecase getDoctorByIdUsecase,
  })  : _getDoctorsUsecase = getDoctorsUsecase,
        _getDoctorByIdUsecase = getDoctorByIdUsecase,
        super(const DoctorState());

  Future<void> getDoctors({
    String? specialization,
    String? searchQuery,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getDoctorsUsecase(GetDoctorsParams(
      specialization: specialization,
      searchQuery: searchQuery,
    ));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
        status: DoctorStatus.error,
      ),
      (doctors) => state = state.copyWith(
        isLoading: false,
        doctors: doctors,
        status: DoctorStatus.success,
      ),
    );
  }

  Future<void> getDoctorById(String doctorId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getDoctorByIdUsecase(
      GetDoctorByIdParams(doctorId: doctorId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
        status: DoctorStatus.error,
      ),
      (doctor) => state = state.copyWith(
        isLoading: false,
        selectedDoctor: doctor,
        status: DoctorStatus.success,
      ),
    );
  }

  void clearSelectedDoctor() {
    state = state.copyWith(selectedDoctor: null);
  }
}
```

**File:** `lib/features/doctors/presentation/pages/doctors_list_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medilink/features/doctors/presentation/view_model/doctor_view_model.dart';
import 'package:medilink/features/doctors/presentation/states/doctor_state.dart';
import 'package:medilink/features/doctors/presentation/pages/doctor_detail_screen.dart';

class DoctorsListScreen extends ConsumerStatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  ConsumerState<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends ConsumerState<DoctorsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSpecialization;

  @override
  void initState() {
    super.initState();
    // Load doctors on init
    Future.microtask(() => ref.read(doctorViewModelProvider.notifier).getDoctors());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    ref.read(doctorViewModelProvider.notifier).getDoctors(
      searchQuery: _searchController.text,
      specialization: _selectedSpecialization,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search doctors...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _handleSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (_) => _handleSearch(),
                ),
                const SizedBox(height: 8),
                // Specialization filter dropdown
                DropdownButtonFormField<String>(
                  value: _selectedSpecialization,
                  decoration: InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Specializations'),
                    ),
                    ...['Cardiology', 'Dermatology', 'Pediatrics', 'Neurology']
                        .map((spec) => DropdownMenuItem(
                              value: spec,
                              child: Text(spec),
                            )),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedSpecialization = value);
                    _handleSearch();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.error}'),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(doctorViewModelProvider.notifier)
                            .getDoctors(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : state.doctors.isEmpty
                  ? const Center(child: Text('No doctors found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = state.doctors[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: doctor.profilePicture != null
                                  ? CachedNetworkImageProvider(
                                      doctor.profilePicture!)
                                  : null,
                              child: doctor.profilePicture == null
                                  ? Text(doctor.firstName[0])
                                  : null,
                            ),
                            title: Text(
                              'Dr. ${doctor.fullName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.specialization),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    Text(' ${doctor.rating.toStringAsFixed(1)} '
                                        '(${doctor.reviewCount} reviews)'),
                                  ],
                                ),
                                Text(
                                  '\$${doctor.consultationFee.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetailScreen(
                                    doctorId: doctor.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
```

**File:** `lib/features/doctors/presentation/pages/doctor_detail_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medilink/features/doctors/presentation/view_model/doctor_view_model.dart';

class DoctorDetailScreen extends ConsumerStatefulWidget {
  final String doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  ConsumerState<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends ConsumerState<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(doctorViewModelProvider.notifier)
        .getDoctorById(widget.doctorId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorViewModelProvider);
    final doctor = state.selectedDoctor;

    if (state.isLoading || doctor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${doctor.fullName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: doctor.profilePicture != null
                        ? CachedNetworkImageProvider(doctor.profilePicture!)
                        : null,
                    child: doctor.profilePicture == null
                        ? Text(
                            doctor.firstName[0],
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${doctor.fullName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          doctor.specialization,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            Text(
                              ' ${doctor.rating.toStringAsFixed(1)} '
                              '(${doctor.reviewCount} reviews)',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('About', doctor.bio ?? 'No bio available'),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Experience',
                    '${doctor.experienceYears} years',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Qualification',
                    doctor.qualification ?? 'Not specified',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Hospital',
                    doctor.hospitalName ?? 'Not specified',
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    'Consultation Fee',
                    '\$${doctor.consultationFee.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to booking screen
                      // Navigator.push(...);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Book Appointment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
```

---

### FEATURE 3: Appointments Management ❌

#### Similar implementation pattern as Doctors
- Create domain entities, repositories, and use cases
- Implement data layer with API models and data sources
- Build presentation layer with booking screens

---

### FEATURE 4: Medical Records ❌

#### Similar implementation pattern
- File upload/download handling
- PDF viewer integration
- Image compression before upload

---

## 5. Data Synchronization Strategy

### 5.1 Offline-First Approach

**Implementation:**
```dart
// In Repository
@override
Future<Either<Failure, List<DoctorEntity>>> getDoctors() async {
  try {
    // 1. Try to fetch from network
    if (await _networkInfo.isConnected) {
      final remoteData = await _remoteDataSource.getDoctors();
      
      // 2. Cache the data locally
      await _localDataSource.cacheDoctors(remoteData);
      
      return Right(remoteData.map((m) => m.toEntity()).toList());
    } else {
      // 3. Fallback to cached data
      final cachedData = await _localDataSource.getCachedDoctors();
      
      if (cachedData.isNotEmpty) {
        return Right(cachedData.map((m) => m.toEntity()).toList());
      }
      
      return const Left(CacheFailure(message: 'No cached data available'));
    }
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}
```

### 5.2 Background Sync

**Setup WorkManager:**
```dart
// lib/core/services/sync/background_sync_service.dart
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'syncAppointments':
        // Sync appointments
        break;
      case 'syncMedicalRecords':
        // Sync medical records
        break;
    }
    return Future.value(true);
  });
}

class BackgroundSyncService {
  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static void registerPeriodicSync() {
    Workmanager().registerPeriodicTask(
      "1",
      "syncAppointments",
      frequency: const Duration(hours: 1),
    );
  }
}
```

### 5.3 Real-time Updates (WebSocket)

**WebSocket Service:**
```dart
// lib/core/services/websocket/websocket_service.dart
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  
  void connect(String userId) {
    _channel = WebSocketChannel.connect(
      Uri.parse('${ApiEndpoints.baseUrl}/ws/chat?userId=$userId'),
    );
    
    _channel!.stream.listen((message) {
      // Handle incoming messages
      _handleIncomingMessage(message);
    });
  }
  
  void _handleIncomingMessage(dynamic message) {
    // Parse and emit events
  }
  
  void sendMessage(String message) {
    _channel?.sink.add(message);
  }
  
  void disconnect() {
    _channel?.sink.close();
  }
}
```

---

## 6. Testing Strategy

### 6.1 Unit Tests

**Test structure matches code structure:**
```
test/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── usecases/
│   │   │   └── repositories/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └──datasources/
│   │   └── presentation/
│   │       └── view_models/
```

**Example Test:**
```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  test('should return AuthEntity on successful login', () async {
    // Arrange
    const testEmail = 'test@test.com';
    const testPassword = 'password123';
    const testEntity = AuthEntity(
      authId: '1',
      fullName: 'Test User',
      email: testEmail,
      userName: 'test',
    );

    when(() => mockRepository.login(testEmail, testPassword))
        .thenAnswer((_) async => const Right(testEntity));

    // Act
    final result = await usecase(
      const LoginParams(email: testEmail, password: testPassword),
    );

    // Assert
    expect(result, const Right(testEntity));
    verify(() => mockRepository.login(testEmail, testPassword)).called(1);
  });
}
```

### 6.2 Widget Tests

Test UI components in isolation.

### 6.3 Integration Tests

Test complete user flows end-to-end.

---

## 7. Deployment Checklist

### 7.1 Pre-Deployment

- [ ] Update base URL to production backend
- [ ] Configure environment variables
- [ ] Remove debug prints and logs
- [ ] Enable code obfuscation
- [ ] Test on physical devices (Android & iOS)
- [ ] Verify API endpoints work with production backend
- [ ] Test offline functionality
- [ ] Test background sync
- [ ] Configure push notifications
- [ ] Update app icons and splash screens
- [ ] Test deep linking
- [ ] Verify third-party integrations (Google, Apple Sign-In)

### 7.2 Backend Coordination

**Ensure backend provides:**
- [ ] All endpoints documented in API Mapping section
- [ ] Proper CORS configuration
- [ ] JWT token expiry and refresh mechanism
- [ ] File upload size limits
- [ ] WebSocket connection handling
- [ ] Rate limiting appropriate for mobile
- [ ] Error response format consistency

### 7.3 Post-Deployment

- [ ] Monitor crash reports (Firebase Crashlytics)
- [ ] Track API errors
- [ ] Monitor sync performance
- [ ] User feedback collection
- [ ] Performance monitoring

---

## Conclusion

This implementation guide provides a complete roadmap for building the MediLink Flutter app following Clean Architecture principles and synchronizing with the existing backend. Each feature follows the same pattern:

1. **Domain First** - Define entities, repositories, and use cases
2. **Data Layer** - Implement API models, data sources, and repositories
3. **Presentation** - Build UI with proper state management

The architecture ensures:
- ✅ Testability at every layer
- ✅ Separation of concerns
- ✅ Easy maintenance and scalability
- ✅ Framework independence
- ✅ Proper synchronization with backend

Follow this guide step-by-step, implementing one feature at a time while maintaining clean architecture principles throughout.
