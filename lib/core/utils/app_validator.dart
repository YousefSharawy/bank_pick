class AppValidator {
  static bool isEmail(String value) {
    return RegExp(
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
    ).hasMatch(value);
  }
  static bool isUserExpr(String value) {
    return RegExp(
      r"^[A-Za-z]+ [A-Za-z]+$",
    ).hasMatch(value);
  }
  static bool isPhoneExpr(String value) {
    return RegExp(
      r"[0-9]{10}$",
    ).hasMatch(value);
  }

}
