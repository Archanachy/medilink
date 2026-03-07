# Android vs Web Doctor Configuration Gap Report

Date: 2026-03-04
Scope compared:
- Android Flutter app: `/Users/archanachaudhary/Documents/ Developer/Flutter/medilink`
- Web app/API client: `/Users/archanachaudhary/Documents/Web API /medilink`

## 1) Current Doctor Configuration (Android)

### Login/Auth
- Android login request sends only:
  - `email`, `password`
- File: `lib/features/auth/data/datasources/remote/auth_remote_datasource.dart`
- Role is persisted in session only if returned by backend (`saveUserSession(role: user.role)`), but login does not request role explicitly.

### Post-login Routing
- App always routes to `/dashboard`.
- Role-based tabs are now handled inside `DashboardScreen`:
  - doctor tabs: Appointments, Messages, Profile
  - patient tabs: Home, Appointments, Doctors, Profile
- File: `lib/features/dashboard/presentation/pages/dashboard_screen.dart`

### Doctor Appointments Fetch
- Android picks endpoint by stored role:
  - doctor -> `/auth/appointments/doctor/{id}`
  - patient -> `/auth/appointments/patient/{id}`
- Added fallback on 403 (doctor↔patient endpoint retry).
- File: `lib/features/appointments/data/datasources/appointment_remote_datasource.dart`

### Doctor Messaging Screen
- `ConversationListScreen` currently assumes patient-centric model:
  - extracts doctors from appointments and displays doctors to message.
- For doctor users, this should instead list patients.
- File: `lib/features/chat/presentation/pages/conversation_list_screen.dart`

### Cancel Appointment API
- Android cancel uses `POST /auth/appointments/{id}/cancel`.
- File: `lib/features/appointments/data/datasources/appointment_remote_datasource.dart`

---

## 2) Current Doctor Configuration (Web)

### Login/Auth
- Web login explicitly tries roles in order (`patient`, `doctor`, `admin`) by sending role in request body.
- File: `lib/api/auth.ts`

### Doctor Portal Structure
- Dedicated doctor pages and navigation:
  - `/doctor/dashboard`
  - `/doctor/appointments`
  - `/doctor/patients`
  - `/doctor/chat`
  - `/doctor/availability`
  - `/doctor/profile`
- Files under: `app/doctor/**`

### Doctor Appointment Data Access
- Web doctor pages call:
  - `getAppointments({ doctorId })` -> `/auth/appointments/doctor/{doctorId}`
- File: `lib/api/appointment.ts`

### Role-aware Redirect Pattern
- Web profile route redirects by role (`patient`/`doctor`/`admin`).
- File: `app/user/profile/page.tsx`

### Cancel Appointment API
- Web cancel uses `PATCH /auth/appointments/{id}/cancel`.
- File: `lib/api/appointment.ts`

---

## 3) Key Gaps Causing Android Doctor Issues

1. **Role resolution at login differs**
   - Web explicitly passes role during login attempts.
   - Android does not pass role, so backend can issue a patient token for a doctor credential path depending on backend behavior.
   - Symptom seen: token role `patient` + doctor endpoint => `403 Forbidden`.

2. **Doctor messaging UX is not role-specific**
   - Android doctor tab uses `ConversationListScreen` that builds a list of doctors from appointments (patient flow behavior).
   - Web doctor chat shows patients to the doctor.

3. **Appointment cancel method mismatch risk**
   - Web uses `PATCH`, Android uses `POST`.
   - If backend enforces method, Android cancellation can fail or be inconsistent.

4. **Over-reliance on fallback instead of authoritative role mapping**
   - Android currently retries alternate endpoint on 403 (good safety net), but this masks identity mapping issues.
   - Web relies on explicit role + doctorId context.

5. **Doctor identity mapping is not explicit in Android session model**
   - Web doctor pages treat logged-in user object as doctor identity source.
   - Android may need dedicated doctorId mapping (if backend differentiates userId and doctor profile id in some flows).

---

## 4) Required Changes for Android (Recommended)

## Priority P0 (must do)

1. **Send `role` in login request for deterministic auth**
- Change Android login payload to include `role` selection (or role-attempt strategy same as web).
- Preferred options:
  - Option A: role selector in UI (Patient/Doctor/Admin)
  - Option B: attempt sequence like web (`patient` -> `doctor` -> `admin`) if role unknown
- File to update:
  - `lib/features/auth/data/datasources/remote/auth_remote_datasource.dart`

2. **Make doctor chat list patient-centric**
- For doctor role, derive unique patients from doctor appointments and show patients list.
- Keep current patient behavior as-is.
- File to update:
  - `lib/features/chat/presentation/pages/conversation_list_screen.dart`

3. **Align cancel appointment HTTP method with web/backend contract**
- Prefer `PATCH /auth/appointments/{id}/cancel` in Android data source.
- Keep temporary fallback to POST only if backend still accepts POST.
- File to update:
  - `lib/features/appointments/data/datasources/appointment_remote_datasource.dart`

## Priority P1 (should do)

4. **Add explicit role guard on dashboard entry**
- If role missing after login, force refresh of `/auth/me` (or re-auth) before selecting doctor tabs.
- Prevents wrong tab set due to stale/absent role.
- Files:
  - `lib/features/dashboard/presentation/pages/dashboard_screen.dart`
  - auth/session fetch layer (`/auth/me` integration if present)

5. **Normalize userId vs doctorId mapping**
- Confirm backend expectation for doctor endpoints (`doctor profile id` vs `user id`).
- If needed, resolve doctorId from `/auth/doctors/user/{userId}` and cache it.
- Files:
  - `lib/core/api/api_endpoints.dart` (add helper endpoint if missing)
  - doctor session/profile layer

## Priority P2 (nice to have)

6. **Create dedicated Doctor Dashboard screen/routes**
- Mirror web mental model with explicit doctor navigation entry.
- Improves maintainability vs mixed role tabs in one screen.

7. **Reduce debug token logs in production builds**
- Keep auth diagnostics behind debug-only flags.

---

## 5) Suggested Validation Checklist (after changes)

1. Login as doctor -> JWT role must be `doctor`.
2. Doctor dashboard loads doctor tabs and no patient-only quick actions.
3. Doctor appointments request should hit `/auth/appointments/doctor/{id}` without fallback.
4. Doctor chat list should display patients (not doctors).
5. Cancel appointment should succeed using PATCH.
6. Login as patient still uses patient tabs and patient appointment endpoints.

---

## 6) Immediate Practical Note

Your recent runtime issue (`403` on `/auth/appointments/doctor/...` with a `patient` token) is fully consistent with Gap #1. The fallback patch currently prevents total failure, but the long-term fix is deterministic role-aware login and role-correct session context.
