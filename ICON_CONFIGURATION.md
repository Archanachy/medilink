# Flutter App Icons Configuration
# Add this to pubspec.yaml under dev_dependencies:
#
# dev_dependencies:
#   flutter_launcher_icons: ^0.13.0
#
# Then add this configuration to pubspec.yaml:

flutter_icons:
  image_path: "assets/images/app_icon.png"
  image_path_ios: "assets/images/app_icon_ios.png"
  
  # Android icons
  android: true
  ios: true
  
  # Web icons (optional)
  web:
    generate: true
    image_path: "assets/images/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#0066cc"
  
  # Windows icons (optional)
  windows:
    generate: true
    image_path: "assets/images/app_icon.png"
  
  # macOS icons (optional)
  macos:
    generate: true
    image_path: "assets/images/app_icon.png"
  
  # Linux icons (optional)
  linux:
    generate: true
    image_path: "assets/images/app_icon.png"

  # Adaptive icon for Android 8.0+
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
  
  # Icon color (for adaptive icons)
  min_sdk_android: 21 # Android 5.0+

# Icon Requirements by Platform:
#
# Android:
#   - Launcher icons: 192x192, 144x144, 96x96, 72x72, 48x48 pixels
#   - Adaptive icon foreground: 108x108 pixels (inner 72x72 is visible)
#   - Adaptive icon background: solid color or image
#   - Format: PNG
#
# iOS:
#   - App Icon: 1024x1024 pixels
#   - Supported sizes automatically generated from source
#   - Format: PNG
#   - Alpha: required (no opaque backgrounds)
#
# Web:
#   - Favicon: 16x16, 32x32, 96x96 pixels
#   - Apple touch icon: 192x192 pixels
#   - Format: PNG
#
# Windows:
#   - Icon: 256x256 pixels
#   - Format: ICO or PNG

# Steps to generate icons:
# 1. Prepare a 1024x1024 PNG icon (safe zone: inner 512x512)
# 2. Place at: assets/images/app_icon.png
# 3. Run: flutter pub get
# 4. Run: flutter pub run flutter_launcher_icons:main
# 5. Verify icons generated in android/ and ios/ directories

# Icon Design Guidelines:
# - Ensure at least 8px padding/margin on all sides
# - Use solid, recognizable design
# - Include app name if helpful
# - Avoid transparency on edges for adaptive icons
# - Test on actual devices
# - Ensure high contrast for visibility

# App Icon Sizes Generated Automatically:
#
# Android:
# - res/mipmap-hdpi/ic_launcher.png (72x72)
# - res/mipmap-mdpi/ic_launcher.png (48x48)
# - res/mipmap-xhdpi/ic_launcher.png (96x96)
# - res/mipmap-xxhdpi/ic_launcher.png (144x144)
# - res/mipmap-xxxhdpi/ic_launcher.png (192x192)
#
# iOS:
# - AppIcon.appiconset/ (multiple sizes automatically generated)
