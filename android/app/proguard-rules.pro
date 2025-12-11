# Flutter settings
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# AdMob
-keep class com.google.ads.** { *; }
-keep class com.google.android.gms.ads.** { *; }

# Google Maps
-keep class com.google.android.gms.maps.** { *; }

# Location services
-keep class com.google.android.gms.location.** { *; }

# Image picker
-keep class androidx.core.content.FileProvider { *; }

# Custom model classes (replace with your actual model classes)
-keep class com.tomople.whodat.models.** { *; }

# General optimization rules
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**
-dontwarn io.flutter.util.**
-dontwarn io.flutter.view.**
-dontwarn io.flutter.app.**