abstract class HomeStates {}
class HomeInit implements HomeStates{}
class GetUserNameLoading implements HomeStates{}
class GetUserNameSuccess implements HomeStates{}
class GetUserNameError implements HomeStates{
  String msg;
  GetUserNameError(this.msg);

}
