import 'package:bank_pick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider extends ChangeNotifier{
  bool isLast=false;
  late int currentPage;
  void onPageChanged (int value){
    if(value == 2){
      isLast =true;
    }
    else if(value == 0 || value ==1 ){
      isLast =false;
    }
notifyListeners();
  }
  void nextF(PageController pageController) {
    pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }
  void nextL(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.login);
    stayInLogin();

  }
  Future <void> stayInLogin () async {
    SharedPreferences preferences = await  SharedPreferences .getInstance();
    preferences .setBool("stayHome", true);
    notifyListeners();
  }
}