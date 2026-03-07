# MediLink - Quick Reference & Checklists

## 📋 Pre-Deployment Checklist

### Code Quality
- [ ] Run `flutter analyze` (no issues)
- [ ] Run `flutter test` (all tests passing)
- [ ] Check `flutter doctor` (setup OK)
- [ ] Generate coverage: `flutter test --coverage`

### Build Configuration
- [ ] Update app version in `pubspec.yaml`
- [ ] Update build number
- [ ] Configure environment: `.env.production`
- [ ] Verify API endpoints in `api_endpoints.dart`

### Android Signing
- [ ] Generate keystore: `./android/generate_signing_key.sh`
- [ ] Update `android/key.properties`
- [ ] Verify in `android/app/build.gradle.kts`
- [ ] Test with: `flutter build apk --release`

### iOS Setup
- [ ] Create Apple Developer account
- [ ] Create provisioning profiles
- [ ] Configure Team ID in Xcode
- [ ] Update `ios/Configure.xcconfig`
- [ ] Test with: `flutter build ios --release`

### Branding Assets
- [ ] Prepare app icon (1024x1024px)
- [ ] Prepare splash screen
- [ ] Prepare screenshots (2-8 per store)
- [ ] Write store description
- [ ] Create privacy policy URL

### Firebase Setup
- [ ] Create Firebase project
- [ ] Add Android app configuration
- [ ] Add iOS app configuration
- [ ] Enable Crashlytics
- [ ] Enable Cloud Messaging
- [ ] Add server key to backend

### Store Accounts
- [ ] Google Play Developer account ($25)
- [ ] Apple Developer account ($99/year)
- [ ] Payment method added
- [ ] Privacy policy published

---

## 🚀 Deployment Commands

### Android Build
```bash
# Development
flutter run --debug

# Testing
flutter build apk --release
adb install -r build/app/outputs/apk/release/app-release.apk

# Production
./build_android_release.sh  # macOS/Linux
build_android_release.bat   # Windows
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Build
```bash
# Development
flutter run --debug

# Testing
flutter build ios --release

# Production
./build_ios_release.sh  # macOS/Linux
# Follow prompts to create archive and IPA
# Output: build/ios/ipa/Runner.ipa
```

### Store Upload
```bash
# Google Play (from android/)
# Upload build/app/outputs/bundle/release/app-release.aab

# Apple App Store
# Upload build/ios/ipa/Runner.ipa
# OR use Transporter app
```

---

## 🔑 Key Credentials to Configure

### Firebase
```
Firebase Project ID: 
Firebase API Key: 
Firebase Auth Domain: 
```

### Google Play
```
Developer Account Email: 
Developer Account Password: 
App Bundle ID: com.archana.medilink
```

### Apple App Store
```
Apple ID Email: 
Apple ID Password: 
Team ID: 
Bundle Identifier: com.archana.medilink
```

### Android Keystore
```
Keystore File: android/medilink.keystore
Keystore Password: [SET_DURING_GENERATION]
Key Alias: medilink_key
Key Password: [SET_DURING_GENERATION]
```

### iOS Certificates
```
Development Team: [TEAM_ID]
Signing Certificate: Apple Development / Apple Distribution
Provisioning Profile: MediLink App Store / MediLink Development
```

---

## 📦 Build Artifacts Locations

### Android Release
```
APK:  build/app/outputs/apk/release/app-release.apk
AAB:  build/app/outputs/bundle/release/app-release.aab
Size: ~50-80MB (APK), ~30-50MB (AAB)
```

### iOS Release
```
Archive: build/ios/archive/Runner.xcarchive
IPA:     build/ios/ipa/Runner.ipa
Size:    ~80-120MB
```

---

## 🧪 Testing Checklist

### Functionality
- [ ] Login/Logout works
- [ ] Doctor search functional
- [ ] Appointment booking works
- [ ] Chat messaging works
- [ ] Notifications received
- [ ] Medical records upload/view
- [ ] Offline sync works
- [ ] Token refresh works

### Performance
- [ ] App launches in <2 seconds
- [ ] Smooth UI (60 FPS)
- [ ] No memory leaks
- [ ] Battery usage acceptable
- [ ] Data usage minimal

### Security
- [ ] No credentials in logs
- [ ] HTTPS only
- [ ] Tokens stored securely
- [ ] No sensitive data in cache
- [ ] Crash reports sanitized

### Compatibility
- [ ] Android 5.0+ support
- [ ] iOS 12.0+ support
- [ ] Multiple screen sizes
- [ ] Different orientations
- [ ] Dark mode support

---

## 📊 Version Management

### Version Format
```
Version: MAJOR.MINOR.PATCH
Build: Sequential number
Example: 1.0.0+1
```

### Update pubspec.yaml
```yaml
version: 1.0.0+1  # For releases, increment last number
```

### Rollout Strategy
```
Internal Testing (20 devices)
  ↓ (48 hours)
Closed Testing (500 devices)
  ↓ (24 hours)
Open Testing (5000 devices)
  ↓ (7 days)
Production (20% rollout)
  ↓ (3 days, monitor)
Production (50% rollout)
  ↓ (3 days, monitor)
Production (100% rollout)
```

---

## 🔍 Monitoring Post-Launch

### Daily
- Check Crashlytics for errors
- Review error logs
- Monitor app ratings
- Check user feedback

### Weekly
- Review analytics
- Analyze user behavior
- Check performance metrics
- Plan bug fixes

### Monthly
- Update dependencies
- Review security
- Plan feature updates
- Analyze revenue (if applicable)

---

## 🚨 Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
rm -rf build/
flutter pub get

# Rebuild
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run --release
```

### Signing Issues (Android)
```bash
# Verify keystore
keytool -list -v -keystore android/medilink.keystore

# Regenerate if needed
cd android
./generate_signing_key.sh
```

### Provisioning Issues (iOS)
```bash
# Update provisioning profiles
cd ios
./setup_provisioning.sh

# Verify in Xcode
open ios/Runner.xcworkspace
# Settings > Build Settings > Signing
```

### Crash Issues
1. Check Crashlytics
2. Review error stack trace
3. Reproduce locally
4. Check git log for recent changes
5. Revert if necessary
6. Fix and resubmit

---

## 📚 Documentation References

- **DEPLOYMENT_GUIDE.md** - Full store deployment guide (350+ lines)
- **PROJECT_COMPLETION_REPORT.md** - Project summary and metrics
- **IMPLEMENTATION_TRACKING.md** - Phase-by-phase tracking
- **ICON_CONFIGURATION.md** - App icon setup
- **SPLASH_CONFIGURATION.md** - Splash screen setup

---

## 💡 Tips & Best Practices

### Before Every Release
1. Test on multiple devices/emulators
2. Check all features work
3. Review crash reports
4. Update version number
5. Write release notes
6. Create test builds for QA

### Store Optimization
1. Keep screenshots updated
2. Respond to reviews
3. Monitor ratings
4. Fix low-rated complaints first
5. A/B test descriptions
6. Update icons seasonally if relevant

### Security Reminders
1. Never hardcode credentials
2. Keep secrets in environment variables
3. Use secure storage for tokens
4. Rotate signing certificates yearly
5. Monitor for suspicious activity
6. Keep dependencies updated

### Performance Tips
1. Monitor app size (target <100MB)
2. Optimize images before upload
3. Cache HTTP responses
4. Use lazy loading
5. Profile memory usage
6. Test on low-end devices

---

## 🎯 Next Phase - Post-Launch

### Week 1-2
- Monitor crash reports
- Review user feedback
- Fix critical bugs
- Announce launch

### Month 1
- Optimize based on analytics
- Respond to reviews
- Plan next features
- Gather user feedback

### Month 2-3
- Release feature updates
- Improve performance
- Expand marketing
- Plan V1.1 release

---

## 📞 Support Resources

### Official Documentation
- Flutter: https://flutter.dev/docs
- Dart: https://dart.dev/guides
- Firebase: https://firebase.google.com/docs
- Riverpod: https://riverpod.dev

### Developer Communities
- Flutter Community: https://flutter.dev/community
- StackOverflow: Tag `flutter`
- Reddit: r/FlutterDev
- Discord: Flutter Developers

### App Store Support
- Google Play Console: https://play.google.com/console/support
- Apple App Store: https://developer.apple.com/support
- App Store Connect: Help in top menu

---

## 📋 Final Deployment Checklist

```
PRE-LAUNCH
☐ All features tested
☐ Crashes < 0.5%
☐ Performance OK
☐ Security reviewed
☐ Version bumped
☐ Credentials configured

STORE SETUP
☐ Developer accounts created
☐ App registered in stores
☐ Store listing filled
☐ Screenshots uploaded
☐ Privacy policy linked
☐ Pricing/distribution set

BUILD & SIGN
☐ Keystore generated
☐ Certificates configured
☐ Builds tested
☐ Test builds in TestFlight
☐ Ready for submission

DEPLOYMENT
☐ TestFlight feedback reviewed
☐ Final builds ready
☐ Screenshots finalized
☐ Release notes written
☐ Submitted to stores
☐ Awaiting approval

POST-LAUNCH
☐ Monitoring active
☐ Analytics setup
☐ Support ready
☐ Announcement sent
☐ Team notified
☐ Documentation updated
```

---

**Status:** ✅ Ready for Deployment  
**Last Updated:** February 26, 2026  
**Version:** 1.0.0

*Use this guide throughout the deployment and post-launch phases.*
