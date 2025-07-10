import 'package:bank_pick/feature/auth/view_model/auth_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends Cubit<AuthStates> {
  AuthViewModel() : super(AuthInitState());

  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    emit(RegisterLoading());
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } catch (error) {
      return emit(RegisterError(error.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      emit(LoginSuccess());

    } on AuthException catch (error) {
      if (error.message == 'email_not_confirmed') {
        emit(
          LoginError(
            "Your email hasn't been confirmed. Please check your inbox.",
          ),
        );
      } else {
        emit(LoginError(error.message));
      }
    }
  }
}
