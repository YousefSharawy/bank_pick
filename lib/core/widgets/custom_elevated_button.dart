import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

// class CustomElevatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final double? width;
//   final double? height;
//   final bool isFullWidth;
  
//   const CustomElevatedButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.width,
//     this.height,
//     this.isFullWidth = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height ?? 48.h, // Standard button height
//       width: isFullWidth 
//           ? double.infinity 
//           : width ?? 200.w, // Default width or custom width
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: ColorManager.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//             vertical: 12.h,
//           ),
//           elevation: 2,
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: ColorManager.white,
//             fontSize: FontSizeManager.s15.sp, // Add .sp for responsive font
//             fontWeight: FontWeightManager.semiBold,
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isFullWidth;
  final bool isLoading;
  
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.isFullWidth = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.h,
      width: isFullWidth 
          ? double.infinity 
          : width ?? 350.w,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorManager.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
          ),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? ColorManager.white,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? ColorManager.white,
                  fontSize: (fontSize ?? FontSizeManager.s15).sp,
                  fontWeight: fontWeight ?? FontWeightManager.semiBold,
                ),
              ),
      ),
    );
  }
}