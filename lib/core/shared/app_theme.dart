import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

class AppTheme{
    static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: ColorManager.white,
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorManager.offWhite,
          showSelectedLabels: true,
      showUnselectedLabels: true,
                selectedItemColor: ColorManager.blue,
       ),
       colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        background: Colors.black,
        primary: Colors.black,
      ),
           inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.offWhite.withOpacity(0.9),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.offWhite.withOpacity(0.9),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.offWhite.withOpacity(0.9),
            ),
          ),
        ),
    );
}