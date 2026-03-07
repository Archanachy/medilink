# MediLink Analytics Integration Guide

## Overview
MediLink now includes comprehensive analytics tracking via Firebase Analytics, providing insights into user behavior, feature usage, and app performance.

## Architecture

### AnalyticsService (`lib/core/services/analytics/analytics_service.dart`)
Singleton service that wraps Firebase Analytics with:
- Automatic initialization
- Error handling
- Debug logging
- Typed event methods
- User property management

### AnalyticsRouteObserver (`lib/core/services/analytics/analytics_route_observer.dart`)
Custom RouteObserver that automatically tracks screen views when users navigate.

## Setup

### 1. Initialization
Analytics service is automatically initialized in `main.dart` during app startup:

```dart
await AnalyticsService.instance.initialize();
```

### 2. Route Tracking
Screen views are automatically tracked via AnalyticsRouteObserver. No manual tracking needed for route navigation.

## Available Events

### Authentication
- `logLogin(method: 'email' | 'google')` - User logs in
- `logSignUp(method: 'email' | 'google')` - User signs up
- `logLogout()` - User logs out

### Appointments
- `logAppointmentBooked(...)` - New appointment booked
- `logAppointmentCancelled(...)` - Appointment cancelled
- `logAppointmentRescheduled(...)` - Appointment rescheduled

### Video Consultation
- `logVideoCallStarted(...)` - Video call session starts
- `logVideoCallEnded(...)` - Video call ends

### Payments
- `logPaymentInitiated(...)` - Payment process started
- `logPaymentCompleted(...)` - Payment successful
- `logPaymentFailed(...)` - Payment failed

### Prescriptions
- `logPrescriptionViewed(...)` - User views prescription
- `logPrescriptionDownloaded(...)` - User downloads prescription

### Health Content
- `logArticleViewed(...)` - User reads health article
- `logHealthTipViewed(...)` - User views health tip

### Vitals
- `logVitalRecorded(...)` - User records vital sign
- `logVitalsViewed(...)` - User views vitals history

### Search
- `logSearch(...)` - User performs search

### Emergency
- `logEmergencyServiceContacted(...)` - Emergency service accessed

### Reviews
- `logReviewSubmitted(...)` - User submits doctor review

### Hospitals
- `logHospitalViewed(...)` - User views hospital details

### Settings
- `logSettingChanged(...)` - User changes app setting

### Notifications
- `logNotificationReceived(...)` - Notification received
- `logNotificationOpened(...)` - User opens notification

### Error Tracking
- `logError(...)` - App error occurred

## Usage Examples

### Example 1: Track appointment booking
```dart
await AnalyticsService.instance.logAppointmentBooked(
  doctorId: '123',
  doctorName: 'Dr. Smith',
  specialty: 'Cardiologist',
  appointmentDate: '2024-01-15',
  appointmentType: 'In-person',
);
```

### Example 2: Track payment
```dart
await AnalyticsService.instance.logPaymentCompleted(
  paymentId: 'pay_123',
  amount: 100.0,
  currency: 'USD',
  paymentMethod: 'credit_card',
);
```

### Example 3: Track search
```dart
await AnalyticsService.instance.logSearch(
  query: 'cardiologist',
  searchType: 'doctors',
  resultCount: 5,
);
```

### Example 4: Set user properties
```dart
// Set user ID (done automatically on login)
await AnalyticsService.instance.setUserId(user.id);

// Set custom user property
await AnalyticsService.instance.setUserProperty(
  'user_type',
  'premium',
);
```

## Integration Points

### Current Integrations
1. **AuthViewModel** - Login, signup, logout events with user ID tracking
2. **Main App** - Analytics service initialization
3. **Route Observer** - Automatic screen view tracking (ready for integration)

### Recommended Future Integrations
1. **Appointment ViewModels** - Add booking, cancellation, rescheduling events
2. **Payment ViewModels** - Add payment lifecycle events
3. **Prescription ViewModels** - Add view/download events
4. **Health Content ViewModels** - Add article/tip view events
5. **Vitals ViewModels** - Add recording/viewing events
6. **Search ViewModels** - Add search events
7. **Emergency Features** - Add emergency contact events
8. **Review ViewModels** - Add review submission events
9. **Settings ViewModels** - Add setting change events
10. **Notification Handlers** - Add notification events

## Best Practices

### 1. Event Naming
- Use snake_case for event names
- Be descriptive but concise
- Follow Firebase Analytics naming conventions

### 2. Parameters
- Keep parameter values meaningful
- Avoid PII in analytics data
- Use consistent parameter names across events

### 3. User Properties
- Set user properties early (on login)
- Update when user data changes
- Clear on logout

### 4. Error Handling
- All analytics calls include try-catch
- Failures won't crash app
- Debug logs show analytics activity

### 5. Privacy
- Never track sensitive data (passwords, payment details, medical info)
- Follow HIPAA compliance guidelines
- Respect user privacy settings

## Testing

### Debug Mode
Analytics automatically logs events to console in debug mode:
```
📊 Event: appointment_booked {doctor_id: 123, ...}
📊 Screen View: /appointments
📊 User ID set: user_123
```

### Firebase Console
View real-time events in Firebase Analytics:
1. Open Firebase Console
2. Navigate to Analytics > Events
3. View DebugView for real-time testing
4. Check Events tab for aggregated data

## Performance Considerations

- Analytics calls are asynchronous and non-blocking
- Events are batched and sent periodically
- Minimal performance impact
- Safe to call frequently

## Troubleshooting

### Events Not Showing
1. Check Firebase initialization succeeded
2. Verify Firebase project configuration
3. Check DebugView in Firebase Console
4. Enable analytics debug logging
5. Verify internet connectivity

### Common Issues
- **Firebase not initialized**: Check main.dart initialization
- **Events not appearing**: Wait 24 hours for aggregation or use DebugView
- **User properties not setting**: Verify user is authenticated
- **Screen views not tracking**: Integrate AnalyticsRouteObserver with navigator

## Next Steps

1. **Integrate with ViewModels**: Add analytics calls to all feature viewmodels
2. **Custom Dashboards**: Create custom analytics dashboards in Firebase
3. **A/B Testing**: Use Firebase Remote Config for A/B testing
4. **Crashlytics Integration**: Already integrated for error tracking
5. **Performance Monitoring**: Add Firebase Performance Monitoring
6. **User Segmentation**: Create user segments based on analytics data
7. **Funnel Analysis**: Track conversion funnels for key user flows
8. **Retention Analysis**: Monitor user retention and engagement

## Resources

- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)
- [Analytics Best Practices](https://firebase.google.com/docs/analytics/best-practices)
- [HIPAA Compliance](https://firebase.google.com/support/guides/hipaa)
- [Event Reference](https://support.google.com/analytics/answer/9267735)
