import 'package:bank_pick/core/routes/route_generator.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/feature/auth/view_model/auth_view_model.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/shared/app_bloc_observer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Bloc.observer = AppBlocObserver();

  final showHome = prefs.getBool("stayHome") ?? false;
  await Supabase.initialize(
    url: "https://nlljygpcmkutlvtkkmhp.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sbGp5Z3BjbWt1dGx2dGtrbWhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMxNjIwOTcsImV4cCI6MjA1ODczODA5N30.Rf1n_4Qr4v5cmOgvrRw4erSCLn9Q0X4XU4Nco_2FCNQ",
  );
  runApp(BankPickApp(isHome: showHome));
}

class BankPickApp extends StatelessWidget {
  bool isHome;

  BankPickApp({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
      BlocProvider(create: (_)=>AuthViewModel()),
      ],
      child: ChangeNotifierProvider<OnBoardingProvider>(
        create: (_) => OnBoardingProvider(),
        child: ScreenUtilInit(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute:isHome ? Routes.login : Routes.onBoarding,
          ),
        ),
      ),
    );
  }
}


