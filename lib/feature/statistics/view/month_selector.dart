import 'package:bank_pick/core/models/transaction_model.dart';
import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthSelector extends StatefulWidget {
  const MonthSelector({super.key});

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  int currentYear = DateTime.now().year;
  int lastActiveYear = DateTime.now().year;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  int activeMonthIndex = DateTime.now().month - 1;

  void _checkYearReset() {
    int currentYear = DateTime.now().year;
    if (currentYear != lastActiveYear) {
      lastActiveYear = currentYear;
    }
  }

  void _onMonthTap(int monthIndex) {
    _checkYearReset();

    setState(() {
      activeMonthIndex = monthIndex;
      final cardViewModel = context.read<CardsViewModel>();
      cardViewModel.updateSelectedMonth(monthIndex + 1);
      cardViewModel.getTransactions(); 
    });
  }
 

  @override
  Widget build(BuildContext context) {
    final cardViewModel= context.read<CardsViewModel>();
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            itemCount: 12,
            itemBuilder: (context, index) {
              bool isActive = activeMonthIndex == index;
              return GestureDetector(
                onTap: () => _onMonthTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isActive ? ColorManager.blue : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                  width: 60.w,
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        months[index],
                        style: TextStyle(
                          color: isActive ? ColorManager.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: BlocBuilder<CardsViewModel, CardsStates>(
            builder: (context, state) {
              if (state is LoadingGetTransaction) {
               return  UIUtils.showLoading(context);
              }
              if(cardViewModel.specificTransactions.isEmpty) {
                return Center(
                  child: Text(
                    'No transactions found for ${months[activeMonthIndex]}',
                    style: TextStyle(fontSize: 16.sp, color: ColorManager.gray),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: cardViewModel.specificTransactions.length,
                itemBuilder: (context, index) {
                  return CustomTransactionSection(
                    label: "Transaction",
                    labelType: cardViewModel.specificTransactions[index].f_type,
                    imagepath: AssetsManager.moneyTransferIcon,
                    price: cardViewModel.specificTransactions[index].amount.toString(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
