# MediLink Splash Screen Configuration

## Installation & Setup

Add to `pubspec.yaml` dev_dependencies:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.0
```

## Configuration

Add to `pubspec.yaml`:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  color_dark: "#1A1A1A"
  
  image: assets/images/splash_logo.png
  image_dark: assets/images/splash_logo_dark.png
  
  branding: assets/images/splash_branding.png
  branding_dark: assets/images/splash_branding_dark.png
  
  # Android specific
  android: true
  android_12:
    image: assets/images/splash_logo_android12.png
    icon_background_color: "#FFFFFF"
    
  # iOS specific
  ios: true
  
  # Web specific (optional)
  web: false
  
  # Fullscreen splash
  fullscreen: false
  
  # Information text (like version)
  info_text: "Version 1.0.0"
  info_text_color: "#999999"
  info_text_style:
    fontSize: 14
    fontFamily: "Roboto"
```

## Recommended Splash Screen Specifications

### Image Specifications:
- **Dimensions**: 1080x1920px (9:16 ratio for mobile)
- **Format**: PNG with transparency support
- **Padding**: 10% margin on all sides for safe display
- **Components**:
  - App logo/icon (centered, ~200x200px)
  - App name (below logo if desired)
  - Version info (optional, bottom corner)
  - Branding elements (optional)

### Logo Specifications:
- **Size**: 200x200px minimum (400x400px recommended for clarity)
- **Format**: PNG with transparency
- **Content**: App icon/logo
- **Design**: Should be recognizable at smaller sizes

### Branding Specifications:
- **Size**: Variable (typically 100x50px for text)
- **Format**: PNG with transparency
- **Content**: Company name, tagline, or additional branding
- **Position**: Usually at bottom or bottom-right

### Android 12+ Specific:
- Themed icon: 108x108px
- Background color: Solid color (no gradient)
- Icon must be centered and have transparent areas

## Design Best Practices

1. **Color Scheme**:
   - Use brand colors for consistency
   - Ensure sufficient contrast
   - Consider dark mode with dark variant

2. **Typography**:
   - Use readable fonts (Roboto, SF Pro Display)
   - Minimum font size: 14pt
   - Limit text to app name and version

3. **Performance**:
   - Keep images optimized and compressed
   - Use appropriate resolution for device
   - Avoid large file sizes (< 500KB total)

4. **Duration**:
   - Typical duration: 2-3 seconds
   - Keep it brief to not annoy users
   - Should complete before app fully loads

5. **Accessibility**:
   - High contrast for visibility
   - Avoid text-only splash if possible
   - Support RTL layouts if needed

## Generation Commands

After configuring in `pubspec.yaml`:

```bash
# Generate splash screens
flutter pub run flutter_native_splash:create

# Clean splash screens
flutter pub run flutter_native_splash:remove

# For iOS only
flutter pub run flutter_native_splash:create --path=pubspec.yaml --web

# For Android only
flutter pub run flutter_native_splash:create --path=pubspec.yaml --android
```

## File Structure

```
assets/
├── images/
│   ├── splash_logo.png              # Main logo (light theme)
│   ├── splash_logo_dark.png         # Logo (dark theme, if needed)
│   ├── splash_logo_android12.png    # Android 12+ themed icon
│   ├── splash_branding.png          # Branding/company name
│   └── splash_branding_dark.png     # Branding (dark theme)
```

## Generated Files (Auto-created)

### Android:
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable-hdpi/splash.png`
- `android/app/src/main/res/drawable-mdpi/splash.png`
- `android/app/src/main/res/drawable-xhdpi/splash.png`
- etc.

### iOS:
- Generated in `ios/Runner/` Xcode project
- Integrated into launch storyboard

## Customization Examples

### Dark Mode Support:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  color_dark: "#1A1A1A"
  image: assets/images/splash_light.png
  image_dark: assets/images/splash_dark.png
```

### With Branding:
```yaml
flutter_native_splash:
  image: assets/images/logo.png
  branding: assets/images/company_name.png
  background_color: "#1A73E8"
```

### Fullscreen Splash:
```yaml
flutter_native_splash:
  fullscreen: true
  image: assets/images/splash_full.png
```

## Testing Splash Screen

```dart
// In your app startup code
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Your initialization code
  await initializeApp();
  
  // Splash screen auto-hides when runApp is called
  runApp(const MyApp());
}

// For testing purposes, you can add a delay:
Future.delayed(Duration(seconds: 3), () {
  // App fully loaded
});
```

## Troubleshooting

1. **Splash not showing**:
   - Ensure file paths are correct in pubspec.yaml
   - Run `flutter clean && flutter pub get`
   - Regenerate: `flutter pub run flutter_native_splash:create`

2. **Image distortion**:
   - Check aspect ratio matches device
   - Verify image dimensions are correct
   - Test on actual device, not just emulator

3. **Safe area issues**:
   - Add padding/margin to design
   - Test on different device sizes
   - Consider notches and curved displays

4. **Dark mode not working**:
   - Ensure both light and dark images provided
   - Verify color_dark is specified
   - Test on device with dark mode enabled

## Next Steps

1. Prepare splash screen images (1080x1920px, PNG)
2. Add flutter_launcher_icons dependency
3. Configure in pubspec.yaml
4. Run generation command
5. Test on iOS and Android devices
6. Verify display duration and appearance
