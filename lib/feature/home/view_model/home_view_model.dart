import 'package:bank_pick/core/models/user_model.dart';
import 'package:bank_pick/feature/home/view_model/home_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewModel extends Cubit<HomeStates> {
  HomeViewModel() : super(HomeInit());
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  PostgrestList names = [];
  UserModel? currUser;

  Future<void> getUsers() async {
    emit(GetUserNameLoading());
    try {
      names = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq("id", "$currentUserId");

      currUser = UserModel(
        id: currentUserId ?? "",
        name: names[0]["name"],
        email: "",
        phone: "",
        profileImage: "",
      );

      emit(GetUserNameSuccess());
    } catch (e) {
      emit(GetUserNameError(e.toString()));
    }
  }
}