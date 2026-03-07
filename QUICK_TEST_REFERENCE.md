# 🚀 MediLink Quick Test Reference Card

## One-Command Testing

```bash
# Quick: Run all tests in 5 minutes
./run_tests.sh

# Flutter only: Test Flutter app
./run_tests.sh --flutter-only

# Backend only: Test backend API
./run_tests.sh --backend-only
```

---

## Step-by-Step Testing

### 1️⃣ Start Backend (Terminal 1)
```bash
cd /Users/archanachaudhary/Documents/Web\ API\ /medilink-web-backend
npm run dev
# Wait for: "Server running on port 5050"
```

### 2️⃣ Start Flutter App (Terminal 2)
```bash
cd /Users/archanachaudhary/Documents/\ Developer/Flutter/medilink
flutter run
# Wait for: "To quit, press 'q' / 'Q'"
```

### 3️⃣ Run Tests (Terminal 3)
```bash
cd /Users/archanachaudhary/Documents/\ Developer/Flutter/medilink
flutter test test/integration/comprehensive_api_test.dart
```

---

## Test Coverage Checklist

### ✅ Authentication
- [ ] Login works
- [ ] Register endpoint responds
- [ ] Forgot password endpoint responds

### ✅ Doctors
- [ ] List doctors
- [ ] View doctor detail
- [ ] Check availability

### ✅ Appointments
- [ ] List user appointments
- [ ] Book appointment
- [ ] View appointment detail
- [ ] Get available time slots

### ✅ Prescriptions
- [ ] List prescriptions
- [ ] View prescription detail
- [ ] Download prescription

### ✅ Medical Records
- [ ] List reports
- [ ] Upload report

### ✅ Notifications
- [ ] List notifications
- [ ] Mark as read

### ✅ Chat
- [ ] List chat rooms
- [ ] Send message

### ✅ Support & Content
- [ ] List support tickets
- [ ] View FAQs

### ✅ Dashboard UI
- [ ] All 6 tabs appear
- [ ] No "Emergency" tab
- [ ] No "Hospital" tab
- [ ] All tabs load correctly

---

## Common Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Run with verbose output
flutter test test/integration/comprehensive_api_test.dart -v

# Run specific test group
flutter test test/integration/comprehensive_api_test.dart -k "Doctors"

# Analyze code
flutter analyze

# Check Flutter doctor
flutter doctor

# Backend tests
npm test

# Backend lint
npm run lint
```

---

## Success Indicators

✅ **All Tests Pass:**
- Pass rate > 90%
- 0 critical errors
- Tests complete in <2 minutes

✅ **App Works:**
- Launches without crash
- 6-tab navigation visible
- All tabs load data
- No "Emergency" or "Hospital"

✅ **Backend API:**
- Server runs on port 5050
- MongoDB connected
- All endpoints return 200 or 400 (not 404)

---

## Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Backend won't start | `brew reinstall mongodb-community` |
| Connection refused | Check `npm run dev` is running |
| Test timeout | `flutter test --timeout=60000` |
| Build error | `flutter clean && flutter pub get` |
| Socket.IO fail | Check backend console for errors |

---

## File Locations

📁 **Flutter App**: `/Users/archanachaudhary/Documents/\ Developer/Flutter/medilink`  
📁 **Backend API**: `/Users/archanachaudhary/Documents/Web\ API\ /medilink-web-backend`  
📁 **Flutter Tests**: `test/integration/comprehensive_api_test.dart`  
📁 **Backend Tests**: `src/__tests__/comprehensive-api.test.ts`  
📁 **Postman**: `MEDILINK_POSTMAN_COLLECTION.json`  
📁 **Test Script**: `run_tests.sh`

---

## Expected Output

```
═══════════════════════════════════════════════════════════════
                    TEST RESULTS SUMMARY
═══════════════════════════════════════════════════════════════

Total Tests:    38
✅ Passed:      35
❌ Failed:      0
⏭️  Skipped:     3
Pass Rate:      92.11%

All endpoints working! ✓
```

---

## Next Steps After Testing

1. ✅ Review test results
2. ✅ Check test output for skipped tests
3. ✅ Verify no 404 errors on any endpoint
4. ✅ Test app UI manually (6 tabs)
5. ✅ Import Postman collection for manual testing
6. ✅ Generate coverage reports (optional)
7. ✅ Deploy to production when confident

---

**Test Now:** `./run_tests.sh`  
**Full Guide:** [COMPLETE_TESTING_GUIDE.md](./COMPLETE_TESTING_GUIDE.md)

