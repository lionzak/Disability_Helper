# Flutter-specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Prevent obfuscation of entry points
-keep class com.example.** { *; }

# Keep Awesome Notifications
-keep class com.onesignal.** { *; }

# Keep Google ML Kit
-keep class com.google.mlkit.** { *; }

# Keep Gson (if used)
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

# Keep Retrofit (if used)
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep classes with native methods
-keepclasseswithmembers class * {
    native <methods>;
}

# Optimize code
-dontwarn
