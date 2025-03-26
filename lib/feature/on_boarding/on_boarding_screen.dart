import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/widgets/custom_elevated_button.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_pages.dart';
import 'package:bank_pick/feature/on_boarding/on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    OnBoardingProvider onBoardingProvider =  Provider.of<OnBoardingProvider>(context,listen: false);
    return WillPopScope(
      onWillPop:() async {
        // This will exit the app and return to the home screen
        SystemNavigator.pop();
        return Future.value(false); // Return false to prevent default back navigation
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            PageView(
              onPageChanged:(value) {
               onBoardingProvider.onPageChanged(value);
              },

              controller: pageController,
              children: [
                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: 145,
                  textPadding: 270,
                  title:"""Fastest Payment in
        the world""",
                  subTitle: """Integrate multiple payment methods
         to help you up the process quickly""",
                  image: AssetsManager.onBoarding1,
                ),

                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: 127,
                  textPadding: 242,
                  title:"""     The most Secure 
Platform for Customer""",
                  subTitle: """  Built-in Fingerprint, face recognition
and more, keeping you completely safe""",
                  image: AssetsManager.onBoarding2,
                ),
                OnBoardingPages(
                  pageController: pageController,
                  imagePadding: 120,
                  textPadding: 237,
                  title: """    Paying for Everything is 
      Easy and Convenient""",
                  subTitle: """        Built-in Fingerprint,face recognition 
    and more, keeping you completely safe""",
                  image: AssetsManager.onBoarding3,
                ),
              ],
            ),
            PositionedDirectional(
              top: 500,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
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
                      onDotClicked:
                          (index) => pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          ),
                    ),
                  ),
                  SizedBox(height: 220),
                  CustomElevatedButton(
                    text: "Next",
                    onPressed: () {
                     if(onBoardingProvider.isLast){
                       onBoardingProvider.nextL(context);
                     }
                     else{
                      onBoardingProvider.nextF(pageController);
                     }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
