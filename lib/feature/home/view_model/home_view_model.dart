import 'package:bank_pick/core/models/user_model.dart';
import 'package:bank_pick/feature/home/view_model/home_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewModel extends Cubit<HomeStates> {
  HomeViewModel() : super(HomeInit()) {
    getUsers();
  }

  // Make this nullable and use a getter for safety
  String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;
  
  PostgrestList names = [];
  UserModel? currUser;

  Future<void> getUsers() async {
    emit(GetUserNameLoading());
    try {
      // Check if user is authenticated
      final userId = currentUserId;
      if (userId == null) {
        emit(GetUserNameError("User not authenticated"));
        return;
      }

      // Only fetch if user data is not already loaded
      if (currUser?.name == null) {
        names = await Supabase.instance.client
            .from('users')
            .select()
            .eq("id", userId);

        // Check if user data was found
        if (names.isEmpty) {
          emit(GetUserNameError("User data not found"));
          return;
        }

        // Safely extract user data with null checks
        final userData = names[0];
        if (userData == null) {
          emit(GetUserNameError("Invalid user data"));
          return;
        }

        currUser = UserModel(
          id: userId,
          name: userData["name"]?.toString() ?? "",
          email: userData["email"]?.toString() ?? "",
          phone: userData["phone"]?.toString() ?? "",
        );
      }

      emit(GetUserNameSuccess());
    } catch (e) {
      emit(GetUserNameError(e.toString()));
    }
  }

  // Helper method to refresh user data
  Future<void> refreshUser() async {
    currUser = null;
    await getUsers();
  }

  // Helper method to check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  // Helper method to get user name safely
  String get userName => currUser?.name ?? "Unknown User";

  // Helper method to get user email safely
  String get userEmail => currUser?.email ?? "";

  // Helper method to get user phone safely
  String get userPhone => currUser?.phone ?? "";
}