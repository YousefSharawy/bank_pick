import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';


class UIUtils {
  // static void showLoading(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder:
  //         (_) => Center(
  //           child: Lottie.asset(
  //             AssetsManager.loadingIndicator,
  //             width: 120,
  //             height: 120,
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //   );
  // }

  static Widget showLoading(BuildContext context) => Center(child: Lottie.asset(
    height: 100.h,
    width: 100.w,
    AssetsManager.loadingIndicator));
  // Center(child: Lottie.asset(AssetsManager.loadingIndicator));
  // static void showLoading(BuildContext context) => showDialog(
  //   context: context,
  //   barrierDismissible: false,
  //   builder: (_) => PopScope(
  //     canPop: false,
  //     child: AlertDialog(
  //       content: SizedBox(
  //         height: MediaQuery.sizeOf(context).height * 0.2,
  //         child: const Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             LoadingIndicator(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  // );

  static void hideLoading(BuildContext context) => Navigator.of(context).pop();

  static void showMessage(String message) =>
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
}
