import 'package:bank_pick/core/routes/route_generator.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs =await SharedPreferences.getInstance();
  final showHome = prefs.getBool("stayHome")?? false;
  runApp(BankPickApp(isHome: showHome));
}

class BankPickApp extends StatelessWidget {
   bool isHome;
   BankPickApp({super.key,required this.isHome});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnBoardingProvider>(
      create: (_)=>OnBoardingProvider(),
      child: ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute:  Routes.onBoarding,
        ),
      ),
    );
  }
}
//isHome ? Routes.login :