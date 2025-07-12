import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/routes/routes.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/feature/cards/view/card_stack.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:bank_pick/feature/home/view/CustomHomeIconButton.dart';
import 'package:bank_pick/feature/home/view_model/home_states.dart';
import 'package:bank_pick/feature/home/view_model/home_view_model.dart';
import 'package:bank_pick/feature/settings/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/ui_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeViewModel>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AssetsManager.background),
        ),
      ),
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                    child: Row(
                      children: [
                        BlocBuilder<CardsViewModel, CardsStates>(
                          builder: (context, state) {
                            final settingsProvider =
                                context.read<SettingsViewModel>();

                            return CircleAvatar(
                              foregroundImage:
                                  settingsProvider.image != null
                                      ? FileImage(settingsProvider.image!)
                                      : AssetImage(AssetsManager.avatar),
                              minRadius: 20.r,
                              backgroundColor: ColorManager.offWhite,
                            );
                          },
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome back,",
                              style: TextStyle(
                                fontSize: FontSizeManager.s12,
                                color: ColorManager.gray,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            BlocBuilder<HomeViewModel, HomeStates>(
                              builder: (_, state) {
                                return Text(
                                  homeProvider.currUser?.name ?? "",
                                  style: TextStyle(
                                    fontSize: FontSizeManager.s18,
                                    color: ColorManager.dark,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 115.w),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025.h,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25.h,
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
                  SizedBox(height: 35.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomHomeIconButton(
                        cutsomIcon: Icons.arrow_upward_outlined,
                        label: "Send",
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.sendMoney);
                        },
                      ),

                      CustomHomeIconButton(
                        customImage: Image.asset(AssetsManager.TopUpIcon),
                        label: "TopUp",
                        onPressed:
                            () => Navigator.of(context).pushNamed(Routes.topUp),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: TextStyle(
                            fontSize: FontSizeManager.s18,
                            fontWeight: FontWeightManager.medium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(Routes.allTransactions);
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(color: ColorManager.navyBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Expanded(
                    child: BlocBuilder<CardsViewModel, CardsStates>(
                      builder: (_, state) {
                        final cardsViewModel = context.read<CardsViewModel>();
                        final alltrans = cardsViewModel.allTransactions;
                        if (state is LoadingGetTransaction) {
                          UIUtils.showLoading(context);
                        }

                        return ListView.builder(
                          itemBuilder: (_, index) {
                            return CustomTransactionSection(
                              label: 'Transaction',
                              labelType: alltrans[index].f_type,
                              imagepath: AssetsManager.moneyTransferIcon,
                              price: alltrans[index].amount.toString(),
                            );
                          },
                          itemCount: alltrans.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            BlocBuilder<CardsViewModel, CardsStates>(
              builder: (context, state) {
                if (state is LoadingGetCards ||
                    state is LoadingGetTransaction) {
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
