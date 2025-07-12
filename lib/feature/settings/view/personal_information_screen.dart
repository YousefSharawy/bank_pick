import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/utils/app_validator.dart';
import 'package:bank_pick/core/widgets/custome_text_field.dart';
import 'package:bank_pick/feature/home/view_model/home_states.dart';
import 'package:bank_pick/feature/home/view_model/home_view_model.dart';
import 'package:bank_pick/feature/settings/view_model/settings_states.dart';
import 'package:bank_pick/feature/settings/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeViewModel>();
    final settingsProvider = context.read<SettingsViewModel>();
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        title: const Text('Personal Information'),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                settingsProvider.pickImage();
              },
              child: BlocBuilder<SettingsViewModel, SettingsState>(
                builder: (context, state) {
                  return CircleAvatar(
                    foregroundImage:
                        settingsProvider.image != null
                            ? FileImage(settingsProvider.image!)
                            : AssetImage(AssetsManager.avatar) as ImageProvider,
                    minRadius: 60.r,
                    backgroundColor: ColorManager.offWhite,
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.center,
              child: BlocBuilder<HomeViewModel, HomeStates>(
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
            ),
            SizedBox(height: 30.h),
            Text(
              "Full Name",
              style: TextStyle(
                fontSize: FontSizeManager.s16,
                color: ColorManager.gray,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 25.w,
                  color: ColorManager.gray,
                ),
                SizedBox(width: 16.w),

                Text(
                  homeProvider.currUser?.name ?? "",
                  style: TextStyle(
                    fontSize: FontSizeManager.s16,
                    color: ColorManager.navyBlue,
                  ),
                ),
              ],
            ),
            Divider(color: ColorManager.offWhite, height: 20.h),

            SizedBox(height: 20.h),
            Text(
              "Email Address",
              style: TextStyle(
                fontSize: FontSizeManager.s16,
                color: ColorManager.gray,
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 25.w,
                  color: ColorManager.gray,
                ),
                SizedBox(width: 16.w),

                Text(
                  homeProvider.currUser?.email ?? "",
                  style: TextStyle(
                    fontSize: FontSizeManager.s16,
                    color: ColorManager.navyBlue,
                  ),
                ),
              ],
            ),
            Divider(color: ColorManager.offWhite, height: 20.h),
            SizedBox(height: 20.h),
            Text(
              "Phone Number",
              style: TextStyle(
                fontSize: FontSizeManager.s16,
                color: ColorManager.gray,
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 25.w,
                  color: ColorManager.gray,
                ),
                SizedBox(width: 16.w),

                Text(
                  homeProvider.currUser?.phone ?? "",
                  style: TextStyle(
                    fontSize: FontSizeManager.s16,
                    color: ColorManager.navyBlue,
                  ),
                ),
              ],
            ),
            Divider(color: ColorManager.offWhite, height: 20.h),
          ],
        ),
      ),
    );
  }
}
