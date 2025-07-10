import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/feature/cards/view/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/assets_manager.dart';

class NewCard extends StatelessWidget {
  const NewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity.h,
      width: double.infinity.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsManager.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorManager.transparent,
          leading: Padding(
            padding:  EdgeInsetsDirectional.only(start: 15.w),
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.offWhite,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
          ),
          title: Text(
            "Add New Card",
            style: TextStyle(
              color: ColorManager.navyBlue,
              fontSize: FontSizeManager.s18,
              fontWeight: FontWeightManager.medium,
            ),
          ),
        ),
        body: AddCardScreen(),
      ),
    );
  }
}
// 