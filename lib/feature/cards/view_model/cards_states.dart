abstract class CardsStates {}

class InitCards implements CardsStates {}

class LoadingCards implements CardsStates {}

class GetCardsSuccess implements CardsStates {}

class GetCardsError implements CardsStates {
  String msg;
  GetCardsError(this.msg);
}

class LoadingGetCards implements CardsStates {}

class DisplayCardsSuccess implements CardsStates {}

class DislpalyGetCardsError implements CardsStates {
  String msg;
  DislpalyGetCardsError(this.msg);
}

class GetLimitSuccess implements CardsStates {
 
}

class GetLimitError implements CardsStates {
  String msg;
  GetLimitError(this.msg);
}
//class LimitChanged implements CardsStates {}

class GetLimitLoading implements CardsStates {}

class SetLimitError implements CardsStates {
  String msg;
  SetLimitError(this.msg);
}
class SendMoneyError implements CardsStates {
  String msg;
  SendMoneyError(this.msg);
}
class TreansactionCreateError implements CardsStates {
  String msg;
  TreansactionCreateError(this.msg);
}
class TreansactionGetError implements CardsStates {
  String msg;
  TreansactionGetError(this.msg);
}

class SetLimitLoading implements CardsStates {}

class SetLimitSuccess implements CardsStates {}
class LoadingSendMoney implements CardsStates {}
class SendMoneySuccess implements CardsStates {}
class LoadingTransactionCreation implements CardsStates {}
class TreansactionCreateSuccess implements CardsStates {}
class LoadingGetTransaction implements CardsStates {}
class TreansactionGetSuccess implements CardsStates {}
