import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomTransactionSection extends StatelessWidget {
  //IconData CustomImageIcon;
  String label;
  String labelType;
  String price;
  String imagepath;
   CustomTransactionSection({
    required this.label,
    required this.labelType,
    required this.imagepath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,

                    decoration: BoxDecoration(
                      color: ColorManager.offWhite,
                      image: DecorationImage(
                        image: AssetImage(imagepath),
                        fit: BoxFit.none,
                        scale: 0.60,
                        
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 19.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: FontSizeManager.s16,
                          fontWeight: FontWeightManager.medium,
                          color: ColorManager.navyBlue,
                        ),
                      ),
                      Text(
                        labelType,
                        style: TextStyle(
                          fontSize: FontSizeManager.s12,
                          fontWeight: FontWeightManager.regular,
                          color: ColorManager.darkGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Padding(
            padding:  EdgeInsets.only(right: 10.0.w),
            child: Text(
              "\$${price}",
              style: TextStyle(
                fontSize: FontSizeManager.s16,
                fontWeight: FontWeightManager.medium,
                color: ColorManager.navyBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
