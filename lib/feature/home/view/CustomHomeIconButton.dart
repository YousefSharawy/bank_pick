import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class CustomHomeIconButton extends StatelessWidget {
  IconData ?cutsomIcon;
  Widget ?customImage;
  String label;
  VoidCallback ?onPressed;
  CustomHomeIconButton({required this.label,this.cutsomIcon,this.customImage,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon:  customImage ?? Icon(cutsomIcon),
          style: IconButton.styleFrom(
            fixedSize: Size(54.h, 54.w),
            backgroundColor: ColorManager.offWhite,
            shape: CircleBorder(),
          ),
        ),
        SizedBox(height: 7.h,),
        Text(label),
      ],
    );
  }
}
