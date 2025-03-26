import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomElevatedButton ({required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding:  EdgeInsets.symmetric(horizontal: 170,vertical: 22),
      backgroundColor: ColorManager.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      )
    ), child: Text(text,style: TextStyle(color: ColorManager.white,fontSize: FontSizeManager.s15,fontWeight: FontWeightManager.semiBold),),
    );
  }
}
