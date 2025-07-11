import 'package:bank_pick/core/models/transaction_model.dart';
import 'package:bank_pick/feature/cards/view_model/cards_states.dart';
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/card_model.dart';

class CardsViewModel extends Cubit<CardsStates> {
  CardsViewModel() : super(InitCards()) {
    getCredits();
  }

  double limit = 0;
  int index = 0;
  double spent = 0;
  double currentUserBalance = 0;
  double secondBalance = 0;
  List<String> type = [];
  RealtimeChannel? _channel;
  final userId = Supabase.instance.client.auth.currentUser!.id;

  List<CardModel> cards = [];
  List<TransactionModel> allTransactions = [];
  List<TransactionModel> currentCardTransactions = [];
  String currentCreditCard = "";
  String getCardId(int index) => cards[index].cardNumber;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  int lastActiveMonth = DateTime.now().month;
  List<TransactionModel> specificTransactions = [];
  
  void updateSelectedMonth(int month) {
    currentMonth = month;
  }

  void updateIndex(int newIndex) async {
    index = newIndex;
    currentCreditCard = cards[index].cardNumber;
    await getTransactions();
    await getValue();
  }

  Future setValue(double l) async {
    try {
      emit(SetLimitLoading());
      if (currentMonth != lastActiveMonth) {
        lastActiveMonth = currentMonth;
        await Supabase.instance.client
            .from('cards')
            .update({"limit": 0})
            .eq("card_number", currentCreditCard);
        limit = 0;
        emit(SetLimitSuccess());
        return;
      }

      final cardId = cards[index].cardNumber;
      await Supabase.instance.client
          .from('cards')
          .update({"limit": l})
          .eq("card_number", cardId);

      limit = l;
      emit(SetLimitSuccess());
    } catch (e) {
      emit(SetLimitError(e.toString()));
    }
  }

  Future getValue() async {
    try {
      emit(GetLimitLoading());

      final cardId = cards[index].cardNumber;
      final response = await Supabase.instance.client
          .from("cards")
          .select("limit")
          .eq("card_number", cardId);

      if (response.isNotEmpty) {
        limit = response[0]["limit"]?.toDouble() ?? 0.0;
        emit(GetLimitSuccess());
      } else {
        emit(GetLimitError("No limit data found"));
      }
    } catch (e) {
      emit(GetLimitError(e.toString()));
    }
  }

  Future<void> getCredits() async {
    try {
      emit(LoadingGetCards());
      final response = await Supabase.instance.client
          .from('cards')
          .select()
          .eq('users_id', userId)
          .order('card_number', ascending: true);

      cards.clear();
      cards = response.map((e) => CardModel.fromJson(e)).toList();

      await getTransactions();

      emit(DisplayCardsSuccess());
    } catch (error) {
      emit(DislpalyGetCardsError(error.toString()));
    }
  }

  Future<void> createCredit(
    String cardNumber,
    String expireDate,
    String cardHolderName,
    String cvvCode,
  ) async {
    try {
      emit(LoadingCards());

      await Supabase.instance.client.from('cards').insert({
        "card_number": cardNumber,
        "card_holder": cardHolderName,
        "expire_date": expireDate,
        "cvv": cvvCode,
        "users_id": userId,
      });

      await getCredits();
      emit(GetCardsSuccess());
    } catch (error) {
      emit(GetCardsError(error.toString()));
    }
  }

  Future<void> sendMoney(String credit, String amount) async {
    try {
      final cardId = cards[index].cardNumber;
      double transferAmount = double.parse(amount);

      if (cardId == credit) {
        emit(SendMoneyError("Cannot send money to the same card"));
        return;
      }

      emit(LoadingSendMoney());

      final allCreditsResponse = await Supabase.instance.client
          .from('cards')
          .select()
          .eq("card_number", credit);
      if (allCreditsResponse.isEmpty) {
        emit(SendMoneyError("This card doesn't exist"));
        return;
      }

      final spentResponse = await Supabase.instance.client
          .from("cards")
          .select("spent, limit")
          .eq("card_number", cardId);

      final cardData = spentResponse.first;
      double currentSpent = (cardData["spent"] ?? 0).toDouble();
      double currentLimit = (cardData["limit"] ?? 0).toDouble();

      // Check if transfer would exceed limit
      double newSpent = currentSpent + transferAmount;
      if (newSpent > currentLimit) {
        emit(SendMoneyError("You have exceeded the limit"));
        return;
      }

      await Supabase.instance.client
          .from("cards")
          .update({"spent": newSpent})
          .eq("card_number", cardId);

      final senderBalanceResponse = await Supabase.instance.client
          .from("cards")
          .select("balance")
          .eq("card_number", cardId);

      if (senderBalanceResponse.isEmpty) {
        emit(SendMoneyError("Sender card balance not efficient"));
        return;
      }

      double senderBalance =
          (senderBalanceResponse.first["balance"] ?? 0).toDouble();

      if (senderBalance < transferAmount) {
        emit(SendMoneyError("Insufficient balance"));
        return;
      }
      currentUserBalance = senderBalance;

      double newSenderBalance = senderBalance - transferAmount;
      await Supabase.instance.client
          .from("cards")
          .update({"balance": newSenderBalance})
          .eq("card_number", cardId);

      final recipientBalanceResponse = await Supabase.instance.client
          .from("cards")
          .select("balance")
          .eq("card_number", credit);

      if (recipientBalanceResponse.isEmpty) {
        emit(SendMoneyError("Recipient card not found"));
        return;
      }

      double recipientBalance =
          (recipientBalanceResponse.first["balance"] ?? 0).toDouble();

      double newRecipientBalance = recipientBalance + transferAmount;
      await Supabase.instance.client
          .from("cards")
          .update({"balance": newRecipientBalance})
          .eq("card_number", credit);

      createTransaction(cardId, transferAmount, credit);
      await getTransactions();
      emit(SendMoneySuccess());
    } catch (e) {
      emit(SendMoneyError(e.toString()));
    }
  }

  Future createTransaction(
    String senderCredit,
    double amount,
    String recieverCredit,
  ) async {
    try {
      emit(LoadingTransactionCreation());
      await Supabase.instance.client.from("transactions").insert({
        "credit_number": senderCredit,
        "user_id": userId,
        "amount": amount,
        "f_type": "send money",
      });

      await Supabase.instance.client.from("transactions").insert({
        "credit_number": recieverCredit,
        "user_id": userId,
        "amount": amount,
        "f_type": "receive money",
      });
      await getTransactions();
      emit(TreansactionCreateSuccess());
    } catch (e) {
      emit(TreansactionCreateError(e.toString()));
    }
  }

  Future getTransactions() async {
    try {
      emit(LoadingGetTransaction());

      if (cards.isEmpty) {
        emit(TreansactionGetError("No cards found"));
        return;
      }

      if (currentCreditCard.isEmpty) {
        currentCreditCard = cards[0].cardNumber;
        index = 0;
      }

      List<TransactionModel> tempTransactions = [];

      final currentCardResponse = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq('credit_number', currentCreditCard)
          .order('created_at', ascending: false);

      tempTransactions.addAll(
        currentCardResponse.map((e) => TransactionModel.fromJson(e)).toList(),
      );

      currentCardTransactions.clear();
      currentCardTransactions.addAll(
        currentCardResponse.map((e) => TransactionModel.fromJson(e)).toList(),
      );

      if (cards.length > 1) {
        final secondCardNumber =
            index == 0 ? cards[1].cardNumber : cards[0].cardNumber;

        final secondCardResponse = await Supabase.instance.client
            .from('transactions')
            .select()
            .eq('credit_number', secondCardNumber)
            .order('created_at', ascending: false);

        tempTransactions.addAll(
          secondCardResponse.map((e) => TransactionModel.fromJson(e)).toList(),
        );
      }

      tempTransactions.sort((a, b) => b.created_at.compareTo(a.created_at));

      allTransactions.clear();
      allTransactions.addAll(tempTransactions);

      specificTransactions.clear();
      specificTransactions =
          allTransactions
              .where(
                (tx) =>
                    tx.creditNumber == currentCreditCard &&
                    tx.created_at.year == currentYear &&
                    tx.created_at.month == currentMonth,
              )
              .toList();

      emit(TreansactionGetSuccess());
      _setupRealtimeSubscription();
    } catch (e) {
      emit(TreansactionGetError(e.toString()));
    }
  }

  void _setupRealtimeSubscription() {
    // Cancel existing subscription if any
    _channel?.unsubscribe();

    if (cards.isNotEmpty) {
      _channel =
          Supabase.instance.client
              .channel('transactions_channel')
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'transactions',
                callback: (payload) {
                  try {
                    final newTransaction = TransactionModel.fromJson(
                      payload.newRecord,
                    );
                    final cardNumbers =
                        cards.map((card) => card.cardNumber).toList();
                    if (cardNumbers.contains(newTransaction.creditNumber)) {
                      allTransactions.insert(0, newTransaction);
                      emit(TreansactionGetSuccess());
                    }
                  } catch (e) {
                    print('Error handling new transaction: $e');
                  }
                },
              )
              .subscribe();
    }
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}
