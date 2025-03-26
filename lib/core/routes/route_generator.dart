import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/feature/auth/login_screen.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteGenerator {

  static Route <dynamic> getRoute (RouteSettings settings){
    switch (settings.name){
      case Routes.onBoarding :
        return MaterialPageRoute(builder: (_)=> OnBoardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_)=>LoginScreen());
      default:
        return _unDefinedRoute();
    }

  }
  static Route <dynamic> _unDefinedRoute (){
  return MaterialPageRoute(
    builder: (_)=>WillPopScope(
      onWillPop: () async {
        // This will exit the app and return to the home screen
        SystemNavigator.pop();
        return Future.value(false); // Return false to prevent default back navigation
      },
      child: Scaffold(
        body: Center(child: Text('No route is fined'),),
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
      ),
    )
  );
  }
}