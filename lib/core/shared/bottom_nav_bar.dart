import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/feature/cards/cards_screen.dart';
import 'package:bank_pick/feature/home/view/home_screen.dart';
import 'package:bank_pick/feature/settings/settings_screen.dart';
import 'package:bank_pick/feature/statistics/statistics.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> screens = [
    HomeScreen(),
    CardsScreen(),
    Statistics(),
    SettingsScreen(),
  ];
  int currerntTappedIndex =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
  
        shape: CircularNotchedRectangle(),
        padding: EdgeInsets.zero,
        notchMargin: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.blue,
        
          elevation: 0,
          currentIndex: currerntTappedIndex,
          onTap: (index)=>setState(() {
            currerntTappedIndex =index;
          }),
          items: [
  BottomNavigationBarItem(icon:Image.asset(AssetsManager.homeIcon,color: ColorManager.gray,), label: 'Home'),
  BottomNavigationBarItem(icon: Image.asset(AssetsManager.cardsIcon,color: ColorManager.gray,), label: 'My Cards'),
  BottomNavigationBarItem(icon: Image.asset(AssetsManager.statisticsIcon,color: ColorManager.gray,), label: 'Statistics'),
  BottomNavigationBarItem(icon: Image.asset(AssetsManager.settingsIcon,color: ColorManager.gray,), label: 'Settings'),

       ]   ,
    
        ),
      ),
      body: screens [currerntTappedIndex],
      
    );
  }
}
