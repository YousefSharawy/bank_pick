import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/widgets/custom_elevated_button.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_pages.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();
  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    OnBoardingProvider onBoardingProvider = Provider.of<OnBoardingProvider>(context, listen: false);
    
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // PageView takes full screen
            PageView(
              physics: BouncingScrollPhysics(),
              onPageChanged: (value) {
                onBoardingProvider.onPageChanged(value);
              },
              controller: pageController,
              children: [
                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: screenHeight * 0.1.h,
                  textPadding: screenHeight * 0.2.h,
                  title: """Fastest Payment in
        the world""",
                  subTitle: """Integrate multiple payment methods
   to help you up the process quickly""",
                  image: AssetsManager.onBoarding1,
                ),
                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: screenHeight * 0.077.h,
                  textPadding: screenHeight * 0.185.h,
                  title: """     The most Secure 
Platform for Customer""",
                  subTitle: """  Built-in Fingerprint, face recognition
and more, keeping you completely safe""",
                  image: AssetsManager.onBoarding2,
                ),
                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: screenHeight * 0.077.h,
                  textPadding: screenHeight * 0.179.h,
                  title: """    Paying for Everything is 
      Easy and Convenient""",
                  subTitle: """        Built-in Fingerprint,face recognition 
    and more, keeping you completely safe""",
                  image: AssetsManager.onBoarding3,
                ),
              ],
            ),
            
            // Dots positioned in the center of screen
            Center(
              child: SmoothPageIndicator(
                controller: pageController,
                effect: ExpandingDotsEffect(
                  spacing: 10,
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: ColorManager.dotColor,
                  activeDotColor: ColorManager.blue,
                ),
                count: 3,
                onDotClicked: (index) => pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            
            // Button positioned at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 40.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomElevatedButton(
                  text: "Next",
                  onPressed: () {
                    if (onBoardingProvider.isLast) {
                      onBoardingProvider.nextL(context);
                    } else {
                      onBoardingProvider.nextF(pageController);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}