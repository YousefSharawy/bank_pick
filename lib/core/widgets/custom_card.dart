import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({required this.cardHolderName,required this.cardNumber,required this.expiryDate,required this.cvvCode});
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetsManager.Card,
          opacity: AlwaysStoppedAnimation<double>(0.89),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 19.0.w),
              child: Text(
                cardNumber,
                style: TextStyle(
                  fontSize: FontSizeManager.s24,
                  color: ColorManager.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding:  EdgeInsets.only(left: 20.0.w),
              child: Text(
                cardHolderName,
                style: TextStyle(
                  fontSize: FontSizeManager.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w),
                      child: Text(
                        'Expire Date',
                        style: TextStyle(
                          fontSize: FontSizeManager.s9,
                          color: ColorManager.gray,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w),
                      child: Text(
                        expiryDate,
                        style: TextStyle(
                          fontSize: FontSizeManager.s13,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 13.w),
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w),
                      child: Text(
                        'CVV',
                        style: TextStyle(
                          fontSize: FontSizeManager.s9,
                          color: ColorManager.gray,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w),
                      child: Text(
                        cvvCode,
                        style: TextStyle(
                          fontSize: FontSizeManager.s13,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ],
                ),
              
              ],
            ),
          ],
        ),
      ],
    );
  }
}
