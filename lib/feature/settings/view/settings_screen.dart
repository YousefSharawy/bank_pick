import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:bank_pick/feature/home/view_model/home_states.dart';
import 'package:bank_pick/feature/home/view_model/home_view_model.dart';
import 'package:bank_pick/feature/settings/view_model/settings_states.dart';
import 'package:bank_pick/feature/settings/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 10.0.w),
            child: IconButton(
              onPressed: () {
                logOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, size: 27),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Row(
              children: [
               BlocBuilder<SettingsViewModel, SettingsState>(
  builder: (context, state) {
    final settingsProvider = context.read<SettingsViewModel>();
    return CircleAvatar(
      foregroundImage: settingsProvider.imageUrl != null
          ? NetworkImage(settingsProvider.imageUrl!)
          : AssetImage(AssetsManager.avatar),
      minRadius: 30.r,
      backgroundColor: ColorManager.offWhite,
    );
  },
),
                SizedBox(width: 16.w),
                BlocBuilder<HomeViewModel, HomeStates>(
                  builder: (_, state) {
                    return Text(
                      homeProvider.currUser?.name ?? "",
                      style: TextStyle(
                        fontSize: FontSizeManager.s18,
                        color: ColorManager.dark,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.personalInformation);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 30.w,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 16.w),

                  Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: FontSizeManager.s14,
                      color: ColorManager.navyBlue,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.w,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 20.w), // Add padding from right edge
                ],
              ),
            ),
            Divider(color: ColorManager.offWhite, height: 10.h),

          ],
        ),
      ),
    );
  }

  void logOut() {
    BlocProvider.of<SettingsViewModel>(context).logOut();
  }
}
