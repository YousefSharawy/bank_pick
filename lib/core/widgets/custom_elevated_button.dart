import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomElevatedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.07.h  ,
      width: MediaQuery.sizeOf(context).width * 0.8.w ,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // padding: EdgeInsetsDirectional.symmetric(
          //  horizontal: MediaQuery.sizeOf(context).width*0.25.w,
          //  vertical: MediaQuery.sizeOf(context).height*0.01.h,
          // ),
          backgroundColor: ColorManager.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: ColorManager.white,
            fontSize: FontSizeManager.s15,
            fontWeight: FontWeightManager.semiBold,
          ),
        ),
      ),
    );
  }
}
