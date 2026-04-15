## Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Hive
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }

## Google Play Core (fix SplitCompatApplication missing)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
