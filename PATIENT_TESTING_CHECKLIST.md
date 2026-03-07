# MediLink Patient App - Testing Checklist

**Date:** March 4, 2026  
**Tester:** _________________  
**Device:** _________________  
**OS Version:** _________________

---

## 1. Authentication & Onboarding

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Splash screen loads correctly | | |
| [ ] Onboarding slides (can skip/complete) | | |
| [ ] User registration with email/password | | |
| [ ] Email validation on signup | | |
| [ ] Login with valid credentials | | |
| [ ] Login error handling (wrong password) | | |
| [ ] Forgot password sends reset email | | |
| [ ] Reset password with token works | | |
| [ ] Session persists after app restart | | |
| [ ] Logout clears session completely | | |

**Pass Rate:** ___/10

---

## 2. Dashboard/Home Screen

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Welcome message shows user name | | |
| [ ] Quick action cards visible (4 cards) | | |
| [ ] Upcoming appointments section loads | | |
| [ ] Shows only future appointments | | |
| [ ] Excludes completed/cancelled appointments | | |
| [ ] Appointments sorted by nearest date | | |
| [ ] Recent medical records section loads | | |
| [ ] Pull-to-refresh works | | |
| [ ] Navigation from quick actions works | | |
| [ ] Loading states show correctly | | |

**Pass Rate:** ___/10

---

## 3. Appointments

### 3.1 View Appointments
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Tap "View All" from dashboard | | |
| [ ] Appointments list loads without crash | | |
| [ ] All appointments display with correct info | | |
| [ ] Doctor name, date, time visible | | |
| [ ] Status badge shows (scheduled/completed/cancelled) | | |
| [ ] Pull-to-refresh updates list | | |
| [ ] Empty state shows if no appointments | | |

**Pass Rate:** ___/7

### 3.2 Book Appointment
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to booking screen | | |
| [ ] Select doctor from list | | |
| [ ] Choose date (date picker opens) | | |
| [ ] Choose time slot | | |
| [ ] Enter reason for visit | | |
| [ ] Submit booking successfully | | |
| [ ] Success message appears | | |
| [ ] New appointment appears in list | | |

**Pass Rate:** ___/8

### 3.3 Appointment Details
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Tap appointment card opens details | | |
| [ ] All info displays correctly | | |
| [ ] Doctor details visible | | |
| [ ] Date, time, duration shown | | |
| [ ] "Send Message" button works | | |
| [ ] "Cancel Appointment" button visible | | |
| [ ] Cancellation confirmation dialog appears | | |
| [ ] Appointment cancels successfully | | |

**Pass Rate:** ___/8

---

## 4. Doctor Discovery

### 4.1 Doctor List
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Doctors screen | | |
| [ ] Doctor list loads | | |
| [ ] Profile photo, name, specialization shown | | |
| [ ] Consultation fee displayed | | |
| [ ] Rating/stars visible | | |
| [ ] Search doctors by name works | | |
| [ ] Filter by specialization works | | |
| [ ] Sort options work (fee, rating, name) | | |

**Pass Rate:** ___/8

### 4.2 Doctor Profile
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Tap doctor card opens profile | | |
| [ ] Full profile information displays | | |
| [ ] Bio/about section shows | | |
| [ ] Availability schedule visible | | |
| [ ] Reviews and ratings load | | |
| [ ] "Book Appointment" button works | | |
| [ ] "Send Message" button navigates to chat | | |

**Pass Rate:** ___/7

---

## 5. Real-Time Chat

### 5.1 Chat List
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Messages/Conversations | | |
| [ ] Conversation list loads | | |
| [ ] Last message preview shown | | |
| [ ] Unread indicators visible (if any) | | |
| [ ] Search conversations works | | |

**Pass Rate:** ___/5

### 5.2 Live Chat
| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Open chat with doctor | | |
| [ ] Socket.IO connection establishes | | |
| [ ] Message history loads | | |
| [ ] Can send text message | | |
| [ ] Message appears immediately | | |
| [ ] Scroll to latest message works | | |
| [ ] Timestamp displays on messages | | |
| [ ] **CRITICAL**: Go back and reopen chat | | |
| [ ] **CRITICAL**: Message history persists | | |
| [ ] Auto-reconnect after network loss | | |

**Pass Rate:** ___/10

**⚠️ Critical Test:** Send message → go back → reopen same chat → verify message is still there

---

## 6. Medical Records

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Medical Records | | |
| [ ] Records list loads | | |
| [ ] Record cards show type, date, doctor | | |
| [ ] Filter by record type works | | |
| [ ] Search records works | | |
| [ ] Sort by date (newest/oldest) | | |
| [ ] Tap record opens details | | |
| [ ] Full record information displays | | |
| [ ] File attachments visible (if any) | | |
| [ ] Upload record screen accessible | | |
| [ ] **TEST**: Upload a PDF record | | |
| [ ] **TEST**: Download/view record file | | |

**Pass Rate:** ___/12

---

## 7. Prescriptions

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Prescriptions | | |
| [ ] Prescription list loads | | |
| [ ] Prescription cards show medication info | | |
| [ ] Filter by status (active/expired) | | |
| [ ] Tap prescription opens details | | |
| [ ] Medication list with dosage shows | | |
| [ ] Doctor info and date visible | | |
| [ ] Special instructions display | | |
| [ ] **TEST**: Download prescription (if available) | | |

**Pass Rate:** ___/9

---

## 8. Emergency Services

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Emergency screen | | |
| [ ] Emergency contacts displayed | | |
| [ ] Hotline numbers visible | | |
| [ ] Nearest hospitals list/map loads | | |
| [ ] "Request Ambulance" button works | | |
| [ ] Ambulance request form opens | | |
| [ ] Can enter emergency details | | |
| [ ] Location auto-populates (if enabled) | | |
| [ ] Submit ambulance request | | |

**Pass Rate:** ___/9

---

## 9. Hospitals

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Hospitals screen | | |
| [ ] Hospital list loads | | |
| [ ] Hospital cards show name, address | | |
| [ ] Search hospitals works | | |
| [ ] Filter by services works | | |
| [ ] Tap hospital opens details | | |
| [ ] Full hospital info displays | | |
| [ ] Associated doctors list shows | | |
| [ ] Facilities/services list visible | | |

**Pass Rate:** ___/9

---

## 10. Profile & Settings

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Profile screen | | |
| [ ] User info displays correctly | | |
| [ ] Profile photo shows | | |
| [ ] Name, email, phone visible | | |
| [ ] Navigate to Edit Profile | | |
| [ ] Can update personal info | | |
| [ ] **TEST**: Change profile photo | | |
| [ ] **TEST**: Update phone number | | |
| [ ] Changes save successfully | | |
| [ ] Updated info reflects immediately | | |

**Pass Rate:** ___/10

---

## 11. Notifications

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Navigate to Notifications screen | | |
| [ ] Notification list loads | | |
| [ ] Notifications show type and message | | |
| [ ] Unread notifications highlighted | | |
| [ ] Tap notification navigates to relevant screen | | |
| [ ] Mark as read functionality | | |

**Pass Rate:** ___/6

---

## 12. Navigation & UI/UX

| Feature | Status | Notes |
|---------|--------|-------|
| [ ] Bottom navigation bar works | | |
| [ ] All tabs accessible (Home, Appointments, etc) | | |
| [ ] Back button navigates correctly | | |
| [ ] Deep links work (if applicable) | | |
| [ ] Loading spinners show during data fetch | | |
| [ ] Error messages are user-friendly | | |
| [ ] Empty states display properly | | |
| [ ] Dark mode switches (if enabled) | | |
| [ ] App doesn't crash during normal use | | |
| [ ] App performance is smooth | | |

**Pass Rate:** ___/10

---

## Critical Bug Tests

### High Priority Verifications
| Bug/Issue | Fixed? | Notes |
|-----------|--------|-------|
| [ ] Socket.IO connects without "Connection closed" error | | |
| [ ] Chat history loads and persists on reopen | | |
| [ ] Tapping appointments doesn't crash ("No element" error) | | |
| [ ] Dashboard shows only upcoming appointments | | |
| [ ] Completed/cancelled appointments excluded from home | | |
| [ ] App doesn't crash when appointment list is empty | | |
| [ ] Message sending works consistently | | |

**Pass Rate:** ___/7

---

## Performance Tests

| Test | Pass/Fail | Notes |
|------|-----------|-------|
| [ ] App launches in < 3 seconds | | |
| [ ] Dashboard loads in < 2 seconds | | |
| [ ] Appointment list loads in < 2 seconds | | |
| [ ] Chat messages send in < 1 second | | |
| [ ] No lag when scrolling lists | | |
| [ ] No memory leaks after 10 min use | | |

**Pass Rate:** ___/6

---

## Network & Error Handling

| Scenario | Pass/Fail | Notes |
|----------|-----------|-------|
| [ ] App shows error when offline | | |
| [ ] Retry mechanism works after network restored | | |
| [ ] Invalid credentials show proper error | | |
| [ ] API timeout handled gracefully | | |
| [ ] 404/500 errors show user-friendly messages | | |
| [ ] Socket reconnects after network drop | | |

**Pass Rate:** ___/6

---

## Overall Summary

| Category | Pass Rate | Status |
|----------|-----------|--------|
| 1. Authentication | ___/10 | |
| 2. Dashboard | ___/10 | |
| 3. Appointments | ___/23 | |
| 4. Doctors | ___/15 | |
| 5. Chat | ___/10 | |
| 6. Records | ___/12 | |
| 7. Prescriptions | ___/9 | |
| 8. Emergency | ___/9 | |
| 9. Hospitals | ___/9 | |
| 10. Profile | ___/10 | |
| 11. Notifications | ___/6 | |
| 12. Navigation | ___/10 | |
| Critical Bugs | ___/7 | |
| Performance | ___/6 | |
| Network/Errors | ___/6 | |

**Total Pass Rate:** ____/152

**Overall Status:** 
- [ ] Ready for Production
- [ ] Needs Minor Fixes
- [ ] Needs Major Work

---

## Critical Issues Found

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

## Minor Issues Found

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

## Recommendations

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

**Tested By:** _________________  
**Date Completed:** _________________  
**Sign-off:** _________________
