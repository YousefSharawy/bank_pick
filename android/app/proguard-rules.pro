# Flutter ProGuard Rules - Enhanced for Text Issues
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep ALL text and font related classes
-keep class * extends android.widget.TextView { *; }
-keep class * extends android.text.** { *; }
-keep class android.text.** { *; }
-keep class android.widget.** { *; }
-keep class android.graphics.** { *; }

# Keep Material Design components
-keep class com.google.android.material.** { *; }
-keep class androidx.** { *; }

# Keep button and UI components
-keep class * extends android.widget.Button { *; }
-keep class * extends android.view.View { *; }
-keep class * extends android.view.ViewGroup { *; }

# Supabase related
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-dontwarn io.supabase.**
-dontwarn com.supabase.**

# Keep custom fonts and icons - MORE COMPREHENSIVE
-keep class * extends android.graphics.Typeface { *; }
-keep class * extends android.graphics.fonts.** { *; }
-keep class android.graphics.fonts.** { *; }

# Keep theme and style classes
-keep class * extends android.content.res.Resources { *; }
-keep class * extends android.util.TypedValue { *; }

# General Android
-dontwarn io.flutter.embedding.**
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

# Prevent obfuscation of classes that might affect text rendering
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses