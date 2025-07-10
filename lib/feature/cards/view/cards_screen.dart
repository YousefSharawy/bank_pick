import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/feature/cards/view/card_stack.dart';
import 'package:bank_pick/feature/cards/view/slider.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class CardsScreen extends StatefulWidget {
  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
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
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025.h),

                    // Fixed Cards Section
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 15.0.w),
                      child: SizedBox(
                        height:MediaQuery.of(context).size.height * 0.25.h,
                        child: BlocBuilder<CardsViewModel, CardsStates>(
                        builder: (context, state) {
                          if (state is LoadingGetCards) {
                            return SizedBox.shrink();
                          }
                          return CardStack();
                        },
                                            ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                         SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2.h,
                           child: BlocBuilder<CardsViewModel, CardsStates>(
                             builder: (_, state) {
                               final cardsViewModel = context.read<CardsViewModel>();
                               final cardsTrans = cardsViewModel.currentCardTransactions;
                               if(state is LoadingGetTransaction){
                                  UIUtils.showLoading(context);
                               }
                           
                               return ListView.builder(
                                 itemBuilder: (_, index) {
                                   return CustomTransactionSection(
                                     label: 'Transaction',
                                     labelType: cardsTrans[index].f_type,
                                     imagepath: AssetsManager.moneyTransferIcon,
                                     price: cardsTrans[index].amount.toString(),
                                   );
                                 },
                                 itemCount: cardsTrans.length,
                               );
                             },
                           ),
                         ),
                                             SizedBox(height: 20.h),

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

            // Full screen loading overlay
            BlocBuilder<CardsViewModel, CardsStates>(
              builder: (context, state) {
                if ( state is GetLimitLoading) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Lottie.asset(
                        AssetsManager.loadingIndicator,
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}