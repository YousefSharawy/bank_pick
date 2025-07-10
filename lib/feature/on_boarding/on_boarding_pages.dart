import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/color_manager.dart';
import '../../core/resources/font_manager.dart';

class OnBoardingPages extends StatelessWidget {
  final PageController pageController;
  final double imagePadding;
  final String title;
  final String subTitle;
  final String image;

  final double textPadding;

  const OnBoardingPages({
    required this.pageController,
    required this.imagePadding,
    required this.textPadding,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: imagePadding.h),
          child: Image.asset(image),
        ),
        Padding(
          padding: EdgeInsets.only(top: textPadding).h,
          child: Text(
            title,
            style: TextStyle(
              color: ColorManager.dark,
              fontSize: FontSizeManager.s26,
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsetsDirectional.only(top: 10.h),
          child: Text(
            subTitle,
            style: TextStyle(
              color: ColorManager.gray,
              fontSize: FontSizeManager.s14,
            ),
          ),
        ),
      ],
    );
  }
}
