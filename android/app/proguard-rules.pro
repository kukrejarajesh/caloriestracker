# Flutter
-keep class io.flutter.** { *; }

# Google Play Core (referenced by Flutter deferred components)
-dontwarn com.google.android.play.core.**

# SQLite / Drift
-keep class org.sqlite.** { *; }

# path_provider
-keep class androidx.core.content.FileProvider { *; }
