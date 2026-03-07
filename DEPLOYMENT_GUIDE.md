# MediLink - App Store Deployment Guide

## Overview
This guide covers deploying MediLink to Google Play Store and Apple App Store.

---

## Part 1: Google Play Store Deployment

### Prerequisites
- Google Play Developer Account ($25 one-time fee)
- Valid payment method
- Android app signing keystore (created in Phase 8.5)
- Release APK/AAB (built in Phase 8.8)

### Step 1: Set Up Google Play Console

1. **Create Developer Account**
   - Visit: https://play.google.com/console
   - Sign in with Google Account
   - Accept Developer Agreement and Policies
   - Pay $25 developer fee
   - Set up payment method

2. **Create Application**
   - Click "Create app"
   - Enter name: "MediLink"
   - Select default language: English
   - Select category: Medical or Health & Fitness
   - Select content rating: Rate your app

3. **Complete Store Listing**
   - Go to: All apps > MediLink > Store listing
   - Add app icon (512x512px)
   - Add feature graphic (1024x500px)
   - Add 2-8 screenshots (minimum 2, ideally 4-6)
   - Write compelling description
   - Write short description (80 characters max)
   - Add promotional text and privacy policy

4. **App Content Rating**
   - Click: All apps > MediLink > Content rating
   - Complete questionnaire
   - Submit rating

5. **Privacy Policy**
   - Create privacy policy document
   - Host on website (required)
   - Add link in: Store listing > Privacy policy URL

6. **Target Audience & Content**
   - Go to: All apps > MediLink > Target audience
   - Select: Children (18+) or Adults Only
   - Specify content types

### Step 2: Prepare Release App

```bash
# Build release AAB (recommended for Play Store)
cd /path/to/medilink
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Step 3: Upload to Testing Track

1. **Internal Testing First** (Recommended)
   - Go to: All apps > MediLink > Testing > Internal testing
   - Click "Create new release"
   - Upload app-release.aab
   - Add release notes (what's new)
   - Review and save
   - Share link with testers
   - Minimum 20-48 hours for Play Store review

2. **Closed Testing** (Second Step)
   - Go to: All apps > MediLink > Testing > Closed testing
   - Create new release with tested AAB
   - Select internal test release as base
   - Invite specific testers via email
   - Minimum 24 hours review

3. **Open Testing** (Pre-production)
   - Go to: All apps > MediLink > Testing > Open testing
   - Create new release
   - Can have unlimited testers
   - Requires same review process

4. **Production Release**
   - Go to: All apps > MediLink > Release > Production
   - Click "Create new release"
   - Upload app-release.aab (tested version)
   - Add complete release notes
   - Set rollout percentage (20%, 50%, 100%)
   - **Start with 20% rollout, monitor for issues**
   - If stable, gradually increase to 100%

### Step 4: Store Listing Optimization

**Screenshots** (Required, 2-8 needed):
- Show main features
- Use text overlays explaining features
- Aspect ratio: 9:16 (portrait) or 16:9 (landscape)
- Show in English and target languages if applicable
- Examples:
  1. Find doctors
  2. Book appointments
  3. View medical records
  4. Chat with doctors
  5. Notifications

**Description** (200-4000 characters):
```
MediLink - Your Gateway to Healthcare

Connect with quality doctors and manage your health digitally.

Key Features:
✓ Find & Filter Doctors - Search by specialty, location, ratings
✓ Easy Appointments - Book slots, reschedule, cancel anytime
✓ Medical Records - Secure storage of health documents
✓ Real-time Chat - Consult with doctors instantly
✓ Notifications - Appointment reminders and updates
✓ Offline Access - View downloaded records without internet

Why Choose MediLink?
• HIPAA Compliant - Your data is encrypted and secure
• 24/7 Available - Access healthcare anytime, anywhere
• Multiple Doctors - Choose from verified medical professionals
• User Verified - Real doctors, real appointments

Download now and take control of your health!
```

### Step 5: Monitor & Update

**Analytics**
- Go to: User acquisition > Installs
- Monitor daily active users (DAU)
- Check crash rates
- Review user reviews and ratings

**Version Updates**
- Fix critical bugs immediately
- Roll out features progressively
- Maintain user ratings above 4.0

**Review Management**
- Respond to negative reviews
- Address reported issues
- Update frequently with improvements

---

## Part 2: Apple App Store Deployment

### Prerequisites
- Apple Developer Program ($99/year)
- Mac with Xcode 12+
- iOS code signing certificates
- Provisioning profiles (created in Phase 8.6)
- Release IPA (built in Phase 8.9)

### Step 1: Set Up App Store Connect

1. **Create Developer Account**
   - Visit: https://developer.apple.com
   - Enroll in Apple Developer Program ($99/year)
   - Complete payment and verification

2. **Create App in App Store Connect**
   - Go to: https://appstoreconnect.apple.com
   - Sign in with Apple ID
   - Click "My Apps" > "Create"
   - Select "App"
   - Create Bundle ID: com.archana.medilink
   - Enter name: MediLink
   - Select category: Medical or Health & Fitness
   - Complete setup wizard

3. **Configure App**
   - Go to: App Information
   - Add app icon (1024x1024px)
   - Select region and SKU
   - Set privacy policy URL
   - Set support URL

4. **Pricing & Distribution**
   - Set as free or paid
   - Select territories
   - Choose App Availability (immediate or scheduled)

### Step 2: Create App Store Listing

1. **App Preview & Screenshots**
   - Minimum 2, maximum 10 screenshots per language
   - Recommended sizes:
     - iPhone 6.5": 1284x2778px
     - iPad 12.9": 2048x2732px
   - Use live app screenshots (not marketing images)
   - Add optional text over screenshots
   - Examples:
     1. Doctor search interface
     2. Appointment booking
     3. Medical records
     4. Chat feature

2. **Description & Metadata**
   - **Name**: MediLink (30 characters max)
   - **Subtitle**: Healthcare at Your Fingertips (30 chars)
   - **Description** (4000 chars max):
   ```
   MediLink revolutionizes healthcare access. Seamlessly connect 
   with qualified doctors, manage appointments, and maintain secure 
   medical records - all in one app.
   
   KEY FEATURES:
   • Smart Doctor Search - Filter by specialty, ratings, location
   • Instant Booking - Reserve appointments with real-time updates
   • Medical Records - HIPAA-compliant document storage
   • Live Chat - Connect with doctors instantly
   • Smart Notifications - Never miss an appointment
   
   SECURITY & PRIVACY:
   All data is encrypted end-to-end. We comply with HIPAA and 
   international healthcare privacy standards.
   ```
   - **Keywords**: health, doctors, appointments, medical records, chat
   - **Support URL**: https://medilink.com/support
   - **Privacy Policy URL**: https://medilink.com/privacy

3. **Release Notes** (170 characters max):
   ```
   Version 1.0.0 - Initial Release
   
   Download MediLink today and experience healthcare reimagined!
   ```

4. **Rating Information**
   - Indicate if app contains:
     - Unrestricted web access
     - Violence, adult content, etc.
   - Select age rating: 4+, 12+, 17+

### Step 3: Prepare IPA for Submission

```bash
# Build iOS release
cd /path/to/medilink
flutter build ios --release

# Archive in Xcode (automatic with flutter build)
# IPA location: build/ios/ipa/Runner.ipa
```

### Step 4: Submit for Review

1. **Using Transporter** (Recommended)
   ```bash
   # Download Transporter from App Store
   # or install via:
   brew install transporter
   
   # Upload IPA
   xcrun altool --upload-app \
     -f build/ios/ipa/Runner.ipa \
     -t ios \
     -u APPLE_ID \
     -p APP_PASSWORD
   ```

2. **Using Xcode**
   - Open ios/Runner.xcworkspace
   - Product > Archive
   - Distribute App
   - App Store Connect
   - Upload
   - Auto Signing or Manual Signing
   - Upload

3. **Using App Store Connect**
   - Go to: TestFlight > iOS Builds
   - Add IPA if not in TestFlight yet
   - Go to: App Store > Version
   - Build: Select uploaded build
   - Prepare for Submission
   - Submit for Review

### Step 5: TestFlight (Pre-release Testing)

1. **Invite Testers**
   - Go to: TestFlight > Testers & Groups
   - Create tester group
   - Add email addresses
   - Send invitations

2. **Monitor Test Feedback**
   - View tester crash logs
   - Collect feedback
   - Fix reported issues
   - Update builds as needed

3. **Duration**
   - Testing: 7-14 days recommended
   - Ideally: 50+ testers
   - Minimum: 20 devices

### Step 6: Submit to App Store

1. **Prepare Submission**
   - Go to: App Store > Version
   - Ensure all metadata complete
   - Select build
   - Note any export compliance or content restrictions
   - Save

2. **Submit for Review**
   - Click "Submit for Review"
   - Confirm submission
   - Review takes: 24-48 hours typically
   - You'll receive email with result

3. **After Approval**
   - **Release Immediately**: Published same day
   - **Scheduled Release**: Set date/time for release
   - Choose based on business needs

---

## Part 3: Post-Launch Operations

### Monitoring

**Google Play Store**
```
Console > Analytics:
- Monitor daily active users (DAU)
- Track crash rates
- Review adverse feedback
- Monitor version adoption

Tools:
- Google Play Console
- Firebase Analytics
- Crashlytics
```

**Apple App Store**
```
App Store Connect > Analytics:
- Active devices
- Installs
- Sessions
- Retention
- Crashes

Tools:
- App Store Connect Analytics
- Testflight feedback
- Xcode Organizer
```

### Update Strategy

1. **Critical Bugs** (Submit immediately)
   - Crashes, security issues, data loss
   - Use expedited review if available

2. **Feature Updates** (Monthly/Quarterly)
   - Plan releases in advance
   - Coordinate across platforms
   - Schedule TestFlight testing

3. **Minor Improvements** (Bi-weekly)
   - UI/UX enhancements
   - Performance optimization
   - Bug fixes

### Version Numbering

```
Version: Major.Minor.Patch
- 1.0.0: Initial release
- 1.0.1: Bug fixes
- 1.1.0: New features
- 2.0.0: Major redesign

Build number: Increment with each submission
- 1, 2, 3, ... (sequential)
```

### Release Checklist

- [ ] All tests passing
- [ ] Crash rate < 0.5%
- [ ] Tested on multiple devices/OS versions
- [ ] Screenshots updated
- [ ] Release notes written
- [ ] Privacy policy current
- [ ] Compliance check complete
- [ ] Analytics setup verified
- [ ] Crash reporting configured
- [ ] TestFlight review period met (iOS)
- [ ] Approval from QA team
- [ ] Marketing team notified

---

## Troubleshooting

### Google Play Store Issues

**"App not optimized for this device"**
- Ensure AndroidX migration
- Check target SDK version
- Test on multiple API levels

**"Certificate signature not recognized"**
- Verify keystore path and password
- Check build.gradle.kts signing config
- Regenerate keystore if needed

### Apple App Store Issues

**"Certificate has expired"**
- Renew iOS Developer certificate
- Create new provisioning profiles
- Update Xcode project settings

**"IPA file invalid"**
- Verify code signing certificate
- Check bundle identifier matches
- Ensure all dependencies linked

**"Rejected for platform guideline violations"**
- Review rejection reason
- Common issues: crashes, inadequate functionality
- Resubmit after fixes

---

## Contact & Support

**Google Play Store Support**
- https://support.google.com/googleplay
- Email: support@google.com

**Apple App Store Support**
- https://developer.apple.com/support
- Contact: app-review@apple.com

**MediLink Support**
- Website: https://medilink.com
- Email: support@medilink.com
- Status: https://status.medilink.com

---

## Compliance & Best Practices

1. **Data Privacy**
   - HIPAA compliance (US)
   - GDPR compliance (EU)
   - CCPA compliance (California)
   - Local healthcare regulations

2. **Security**
   - End-to-end encryption
   - Certificate pinning
   - Secure token storage
   - Regular security audits

3. **Code Quality**
   - < 0.5% crash rate target
   - Performance optimization
   - Memory leak prevention
   - Regular dependency updates

4. **User Experience**
   - Fast app launch (<2s)
   - Responsive UI (<16ms frame time)
   - Intuitive navigation
   - Clear error messages

---

**Last Updated**: 2024
**Status**: Ready for Production
