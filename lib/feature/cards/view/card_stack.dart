import 'dart:math';

import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/utils/ui_utils.dart';
import 'package:bank_pick/core/widgets/custom_card.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bank_pick/feature/cards/view_model/cards_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CardStack extends StatefulWidget {
  const CardStack({super.key});

  @override
  State<CardStack> createState() => _CardStackPageState();
}

class _CardStackPageState extends State<CardStack> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsViewModel, CardsStates>(
      builder: (context, state) {
       
        final bloc = BlocProvider.of<CardsViewModel>(context);
        return Column(
          children: [
            SizedBox(
              height: 220.h,
              child: CardSwiper(
                controller: controller,
                cardsCount: bloc.cards.length,
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                initialIndex: bloc.index,
                numberOfCardsDisplayed: min(3, bloc.cards.length),
                backCardOffset: const Offset(50, 50),
                padding: const EdgeInsets.all(20.0),
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) {
                  return CustomCard(
                    cardHolderName: bloc.cards[index].cardHolderName,
                    cardNumber: bloc.cards[index].cardNumber,
                    expiryDate: bloc.cards[index].expireDate,
                    cvvCode: bloc.cards[index].cvvCode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final bloc = BlocProvider.of<CardsViewModel>(context);
    bloc.updateIndex(currentIndex ?? 0);
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undone from the ${direction.name}');
    return true;
  }
}
