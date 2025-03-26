import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          // This will exit the app and return to the home screen
          SystemNavigator.pop();
          return Future.value(false); // Return false to prevent default back navigation
        },
        child: Scaffold());
  }
}
