# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Sign-In
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Stream Video
-keep class io.getstream.** { *; }
-dontwarn io.getstream.**

# SignalR
-keep class com.microsoft.signalr.** { *; }
-dontwarn com.microsoft.signalr.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
