abstract class AuthStates {}

class AuthInitState extends AuthStates {}

class LoginError extends AuthStates {
  String msg;
  LoginError (this.msg);
}
class LoginSuccess extends AuthStates {}
class LoginLoading extends AuthStates {}



class RegisterError extends AuthStates {
  String msg;
  RegisterError (this.msg);
}
class RegisterSuccess extends AuthStates {}
class RegisterLoading extends AuthStates {}
