## R8/ProGuard Obfuscation Rules for MediLink
## This file defines what should NOT be obfuscated to maintain functionality

# Keep all Riverpod providers
-keep class **_$*Provider* { *; }
-keep class **_$*NotifierProvider* { *; }
-keep class **_$*FutureProvider* { *; }
-keep class **_$*StateNotifierProvider* { *; }
-keep class **_$*AsyncValue* { *; }

# Keep Hive related classes
-keep class com.example.hive.** { *; }
-keep class io.hive.** { *; }
-keep class @com.hive.** class * { *; }
-keepclassmembers class * {
  @io.hive.HiveType <fields>;
}

# Keep Dio related classes
-keep class io.swagger.client.** { *; }
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep all model classes (essential for JSON serialization)
-keep class **.*Model { *; }
-keep class **.*Entity { *; }
-keep class **.*State { *; }
-keep class **.*Request { *; }
-keep class **.*Response { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keepclassmembers class ** {
  public static ** values();
  public static ** valueOf(java.lang.String);
}

# Keep Flutter/Lambda related
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep annotations
-keepattributes *Annotation*
-keep @interface ** { *; }

# Keep BuildConfig and R classes
-keep class **.BuildConfig { *; }
-keep class **.R$* { 
    public static <fields>;
}

# Keep WebSocket and networking
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }

# Keep serialization/deserialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep reflection support
-keepclassmembers class * {
    public <init>();
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
