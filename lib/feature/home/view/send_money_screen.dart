import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/utils/app_validator.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/core/widgets/custom_elevated_button.dart';
import 'package:bank_pick/feature/cards/view/card_stack.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendMoneyScreen extends StatelessWidget {
  const SendMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardNumberController = TextEditingController();
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.transparent,
        title: const Text('Send Money'), 
        centerTitle: true
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Form(
          key: formKey,
          child: BlocConsumer<CardsViewModel, CardsStates>(
            listener: (context, state) {
              // Handle side effects here
              if (state is SendMoneySuccess) {
                UIUtils.showMessage('Money sent successfully');
                UIUtils.hideLoading(context);
              } else if (state is SendMoneyError) {
                UIUtils.showMessage('Error: ${state.msg}');
              }
            },
            builder: (context, state) {
              // Handle loading state properly
              if (state is LoadingSendMoney) {
               return UIUtils.showLoading(context);
              }
              
              // Return the normal UI for all other states
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CardsViewModel, CardsStates>(
                    builder: (context, state) {
                      return CardStack();
                    },
                  ),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              children: [
                                Icon(Icons.credit_card, color: Colors.grey),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextFormField(
                                    controller: cardNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Card Number',
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Card number is required';
                                      }
                                      if (!AppValidator.isCreditCardNumber(value)) {
                                        return 'Enter a valid card number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Container(
                          width: 180.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.grey),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Amount is required';
                                    }
                                    final num? amount = num.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Enter a valid amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.18.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: CustomElevatedButton(
                      text: 'Send Money',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<CardsViewModel>().sendMoney(
                            cardNumberController.text,
                            amountController.text,
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}