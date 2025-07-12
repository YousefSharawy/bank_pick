import 'dart:io';
import 'package:bank_pick/feature/settings/view_model/settings_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SettingsViewModel extends Cubit<SettingsState> {
  SettingsViewModel() : super(SettingsInitial()) {
    loadImage();
  }

  File? image;
  static const String _profileImageName = "profile_image.jpg";

  Future<void> logOut() async {
    try {
      emit(LogOutLoading());
      await Supabase.instance.client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("stayHome", false);

      emit(LogOutSuccess());
    } catch (e) {
      emit(LogOutError(e.toString()));
    }
  }

  Future<void> pickImage() async {
    try {
      emit(ImageLoading());

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        emit(SettingsInitial());
        return;
      }
      final savedFile = await _saveImageToPermanentStorage(
        File(pickedFile.path),
      );
      image = savedFile;

      emit(ImageLoadedSuccess());
    } catch (e) {
      emit(ImageLoadedError(e.toString()));
    }
  }

  Future<File?> _saveImageToPermanentStorage(File originalFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageFile = File('${appDir.path}/$_profileImageName');

      // Delete old image if exists
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      final savedFile = await originalFile.copy(imageFile.path);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasProfileImage', true);

      return savedFile;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasImage = prefs.getBool('hasProfileImage') ?? false;

      if (hasImage) {
        final appDir = await getApplicationDocumentsDirectory();
        final imageFile = File('${appDir.path}/$_profileImageName');

        if (await imageFile.exists()) {
          image = imageFile;
          emit(ImageLoadedSuccess());
        } else {
          await prefs.setBool('hasProfileImage', false);
          image = null;
          emit(SettingsInitial());
        }
      } else {
        image = null;
        emit(SettingsInitial());
      }
    } catch (e) {
      emit(ImageLoadedError(e.toString()));
    }
  }
}
