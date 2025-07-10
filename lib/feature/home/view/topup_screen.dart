import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopupScreen extends StatelessWidget {
  const TopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        title: const Text('Top Up Instructions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    AssetsManager.instaPayIcon,
                    width: 40.w,
                    height: 40.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'If you want to top up your cards, follow these instructions with InstaPay:',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                '1. Download the InstaPay app from the App Store or Google Play.\n'
                '2. Register and connect your bank accounts or Meeza card.\n'
                '3. Open the app and select "Transfer".\n'
                '4. Enter your card number and cardholder name.\n'
                '5. Enter the amount you want to top up.\n'
                '6. Confirm the transaction.\n'
                '7. The top-up will be processed instantly 24/7.',
                style: TextStyle(fontSize: 15.sp, height: 1.7),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}