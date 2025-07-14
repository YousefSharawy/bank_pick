import 'dart:io';
import 'package:bank_pick/feature/settings/view_model/settings_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class SettingsViewModel extends Cubit<SettingsState> {
  SettingsViewModel() : super(SettingsInitial()) {
    loadImage();
  }

  String? imageUrl;
  static const String _profileImageUrlKey = "profileImageUrl";
  static const String _fileNameKey = "profileImageFileName";
  static const String _bucketName = "profileimages";

  Future<void> logOut() async {
    try {
      print("Starting logout...");
      emit(LogOutLoading());
      await Supabase.instance.client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("stayHome", false);

      print("Logout successful");
      emit(LogOutSuccess());
    } catch (e) {
      print("Logout error: $e");
      emit(LogOutError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    try {
      print("Starting image picker...");
      emit(ImageLoading());

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        print("No image selected");
        emit(SettingsInitial());
        return;
      }

      print("Image picked: ${pickedFile.path}");
      await uploadImageToSupabase(pickedFile.path);
    } catch (e) {
      print("Pick image error: $e");
      emit(ImageLoadedError(e.toString()));
    }
  }

  Future<void> uploadImageToSupabase(String imagePath) async {
    try {
      print("Starting upload to Supabase...");
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print("User not authenticated");
        emit(ImageLoadedError("User not authenticated"));
        return;
      }

      print("User ID: ${user.id}");
      print("User email: ${user.email}");
      print("User role: ${user.role}");

      // Check if user session is valid
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        print("No valid session found");
        emit(ImageLoadedError("No valid session"));
        return;
      }
      print("Session expires at: ${session.expiresAt}");
      final file = File(imagePath);
      final fileExtension = path.extension(imagePath);

      // SOLUTION 1: Add timestamp to filename to avoid cache issues
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${user.id}/profile_$timestamp$fileExtension';
      print("File name: $fileName");

      // Delete previous image if exists
      final prefs = await SharedPreferences.getInstance();
      final oldFileName = prefs.getString(_fileNameKey);
      if (oldFileName != null) {
        try {
          print("Deleting old image: $oldFileName");
          await Supabase.instance.client.storage.from(_bucketName).remove([
            oldFileName,
          ]);
          print("Old image deleted");
        } catch (e) {
          print("Error deleting old image: $e");
          // Continue even if deletion fails
        }
      }

      // Upload new image
      print("Uploading new image...");
      final uploadResult = await Supabase.instance.client.storage
          .from(_bucketName)
          .upload(fileName, file);
      print("Upload result: $uploadResult");

      // Get public URL
      print("Getting public URL...");
      final publicUrl = Supabase.instance.client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);
      print("Public URL: $publicUrl");

      // Save URL and filename to SharedPreferences
      await prefs.setString(_profileImageUrlKey, publicUrl);
      await prefs.setString(_fileNameKey, fileName);

      imageUrl = publicUrl;
      print("Image uploaded successfully");
      emit(ImageLoadedSuccess());
    } catch (e) {
      print("Upload error: $e");
      emit(ImageLoadedError(e.toString()));
    }
  }

  Future<void> loadImage() async {
    try {
      print("Loading image...");
      final prefs = await SharedPreferences.getInstance();
      final savedImageUrl = prefs.getString(_profileImageUrlKey);
      print("Saved image URL: $savedImageUrl");

      if (savedImageUrl != null && savedImageUrl.isNotEmpty) {
        imageUrl = savedImageUrl;
        print("Image loaded successfully");
        emit(ImageLoadedSuccess());
      } else {
        print("No image URL found");
        imageUrl = null;
        emit(SettingsInitial());
      }
    } catch (e) {
      print("Load image error: $e");
      emit(ImageLoadedError(e.toString()));
    }
  }

  Future<void> deleteImage() async {
    try {
      print("Starting image deletion...");
      emit(ImageLoading());

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print("User not authenticated for deletion");
        emit(ImageLoadedError("User not authenticated"));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final fileName = prefs.getString(_fileNameKey);
      print("Filename to delete: $fileName");

      if (fileName != null) {
        // Delete from Supabase storage
        print("Deleting from Supabase...");
        await Supabase.instance.client.storage.from(_bucketName).remove([
          fileName,
        ]);
        print("Deleted from Supabase");
      }

      await prefs.remove(_profileImageUrlKey);
      await prefs.remove(_fileNameKey);

      imageUrl = null;
      print("Image deletion completed");
      emit(SettingsInitial());
    } catch (e) {
      print("Delete image error: $e");
      emit(ImageLoadedError(e.toString()));
    }
  }
}
