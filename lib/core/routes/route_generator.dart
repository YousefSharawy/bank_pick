import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/core/shared/bottom_nav_bar.dart';
import 'package:bank_pick/feature/auth/view/login_screen.dart';
import 'package:bank_pick/feature/auth/view/register_screen.dart';
import 'package:bank_pick/feature/cards/view/new_card.dart';
import 'package:bank_pick/feature/home/view/all_transactions_screen.dart';
import 'package:bank_pick/feature/home/view/home_screen.dart';
import 'package:bank_pick/feature/home/view/send_money_screen.dart';
import 'package:bank_pick/feature/home/view/topup_screen.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.sendMoney:
        return MaterialPageRoute(builder: (_) => SendMoneyScreen());
      case Routes.allTransactions:
        return MaterialPageRoute(builder: (_) => AllTransactionsScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.navBar:
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case Routes.addCards:
        return MaterialPageRoute(builder: (_) => NewCard());
      case Routes.topUp:
        return MaterialPageRoute(builder: (_) => TopupScreen());
      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          // This will exit the app and return to the home screen
          SystemNavigator.pop();
          return Future.value(false); // Prevent default back navigation
        },
        child: Scaffold(
          body: Center(child: Text('No route found')),
          appBar: AppBar(title: const Text('No Route Found')),
        ),
      ),
    );
  }
}
