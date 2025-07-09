import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/feature/cards/view/card_stack.dart';
import 'package:bank_pick/feature/cards/view/slider.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsScreen extends StatefulWidget {
  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure cards are loaded when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardsProvider = context.read<CardsViewModel>();
      if (cardsProvider.cards.isEmpty) {
        cardsProvider.getCredits();
      }
    });
  }

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.addCards);
                },
                icon: Icon(Icons.add, size: 28),
                padding: EdgeInsets.all(5),
              ),
            ),
          ],
          backgroundColor: ColorManager.transparent,
          title: Text(
            'My Cards',
            style: TextStyle(
              color: ColorManager.navyBlue,
              fontSize: FontSizeManager.s20,
              fontWeight: FontWeightManager.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: ColorManager.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.025.h),

                // Fixed Cards Section
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 15.0.w),
                  child: BlocBuilder<CardsViewModel, CardsStates>(
                    builder: (context, state) {
                      if (state is DisplayCardsSuccess) {
                        final cardsProvider = context.read<CardsViewModel>();
                        if (cardsProvider.cards.isNotEmpty) {
                          return CardStack();
                        } else {
                          return Container(
                            height: 200.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.credit_card_off,
                                    size: 50.r,
                                    color: ColorManager.gray,
                                  ),
                                  SizedBox(height: 10.h),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed(Routes.addCards);
                                    },
                                    child: Text('Add Card'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else if (state is LoadingGetCards) {
                        return Container(
                          height: 200.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.navyBlue,
                            ),
                          ),
                        );
                      } else if (state is DislpalyGetCardsError) {
                        return Container(
                          height: 200.h,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40.r,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Error loading cards',
                                  style: TextStyle(
                                    fontSize: FontSizeManager.s14,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CardsViewModel>().getCredits();
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),

                SizedBox(height: 30.h),
                CustomTransactionSection(
                  label: "Apple Store",
                  labelType: "Entertainment",
                  price: "5,99",
                  imagepath: AssetsManager.appleIcon,
                ),
                CustomTransactionSection(
                  label: "Spotify",
                  labelType: "Music",
                  price: "12,99",
                  imagepath: AssetsManager.spotifyIcon,
                ),
                CustomTransactionSection(
                  label: "Money",
                  labelType: "Transaction",
                  price: "300",
                  imagepath: AssetsManager.moneyTransferIcon,
                ),
                CustomTransactionSection(
                  label: "Grocery",
                  labelType: "Shopping",
                  price: "88",
                  imagepath: AssetsManager.shopIcon,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.0.w),
                  child: Text(
                    'Monthly spending limit',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorManager.navyBlue,
                      fontSize: FontSizeManager.s18,
                      fontWeight: FontWeightManager.medium,
                    ),
                  ),
                ),
                CustomSlider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
