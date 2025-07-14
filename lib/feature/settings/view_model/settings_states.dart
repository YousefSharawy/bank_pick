abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class LogOutSuccess extends SettingsState {}

class LogOutLoading extends SettingsState {}

class LogOutError extends SettingsState {
  final String message;

  LogOutError(this.message);
}

class ImageLoading extends SettingsState {}

class ImageLoadedSuccess extends SettingsState {}

class ImageLoadedError extends SettingsState {
  final String message;

  ImageLoadedError(this.message);
}

class ResetPasswordSuccess extends SettingsState {}

class ResetPasswordError extends SettingsState {
  final String message;

  ResetPasswordError(this.message);
}

class ResetPasswordLoading extends SettingsState {}
