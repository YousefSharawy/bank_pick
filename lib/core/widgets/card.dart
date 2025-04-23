import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

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
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0),
              child: Text(
                '4090 0000 1532 0479',
                style: TextStyle(
                  fontSize: FontSizeManager.s24,
                  color: ColorManager.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Yousef Ahmed',
                style: TextStyle(
                  fontSize: FontSizeManager.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Expire Date',
                        style: TextStyle(
                          fontSize: FontSizeManager.s9,
                          color: ColorManager.gray,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '24/2000',
                        style: TextStyle(
                          fontSize: FontSizeManager.s13,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 13),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'CVV',
                        style: TextStyle(
                          fontSize: FontSizeManager.s9,
                          color: ColorManager.gray,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '9866',
                        style: TextStyle(
                          fontSize: FontSizeManager.s13,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 75),
                Column(
                  children: [
                    Image.asset(AssetsManager.masterCardIcon),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        'mastercard',
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
