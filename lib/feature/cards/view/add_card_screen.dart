import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<StatefulWidget> createState() => AddCardScreenState();
}

class AddCardScreenState extends State<AddCardScreen> {
  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useBackgroundImage = true;
  bool useFloatingAnimation = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.transparent,
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                CreditCardWidget(
                  cardBgColor: ColorManager.gray,
                  chipColor: ColorManager.transparent,
                  enableFloatingCard: false,
                  cardNumber: cardNumber,
                  expiryDate: expireDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  backgroundImage: AssetsManager.Card,
                  glassmorphismConfig: Glassmorphism(
                    blurX: 1.0,
                    blurY: 1.0,
                    gradient: LinearGradient(
                      colors: <Color>[
                        ColorManager.offWhite.withOpacity(0.01),
                        ColorManager.offWhite.withOpacity(0.01),
                      ],
                    ),
                  ),
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},

                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        AssetsManager.masterCardIcon,
                        height: 48.h,
                        width: 48.w,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expireDate,
                          inputConfiguration: const InputConfiguration(
                            cardHolderDecoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_2_outlined),
                              labelText: 'Card Holder',
                            ),
                            expiryDateDecoration: InputDecoration(
                              labelText: 'Expired Date',
                              hintText: 'XX/XX',
                            ),
                            cvvCodeDecoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: 'XXX',
                            ),

                            cardNumberDecoration: InputDecoration(
                              prefixIcon: Icon(Icons.credit_card_outlined),
                              labelText: 'Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                            ),
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),

                        BlocListener<CardsViewModel, CardsStates>(
                          listener: (_, state) {
                            if (state is GetCardsSuccess) {
                              UIUtils.hideLoading(context);
                              UIUtils.showMessage('Card add Successfully');
                            } else if (state is GetCardsError) {
                              UIUtils.hideLoading(context);
                              UIUtils.showMessage(
                                'Can\'t have more than two cards',
                              );
                            } else if (state is LoadingCards) {
                              UIUtils.showLoading(context);
                            }
                          },
                          child: GestureDetector(
                            onTap: addNewCard,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: MediaQuery.sizeOf(context).height * 0.15,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.r),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              alignment: Alignment.center,
                              child: Text(
                                'Add Card +',
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSizeManager.s16,
                                  fontWeight: FontWeightManager.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addNewCard() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<CardsViewModel>(
        context,
      ).createCredit(cardNumber, expireDate, cardHolderName, cvvCode);
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expireDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
