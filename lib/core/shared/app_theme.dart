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
    );
}