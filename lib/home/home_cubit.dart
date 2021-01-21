import 'dart:ffi';

import 'package:my_investment/base/base_cubit.dart';
import 'package:my_investment/model/coin_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeCubit extends BaseCubit {


  BehaviorSubject<List<CoinModel>> listCoins = BehaviorSubject();
  HomeCubit() {
  }

  getListCoin() async {
    showLoading();
    await Future.delayed(Duration(seconds: 2));
    listCoins.sink.add(List<CoinModel>.generate(20, (index){
      CoinModel coin = CoinModel();
      coin.name ="Coin $index";
      coin.symbol = "Btc $index";
      coin.priceBuy = 39000 ;
      coin.priceNow = 40000;
      coin.amount = 1.2;
      return coin;
    }));
    hideLoading();
  }
  showLoading() {
    bsLoading.sink.add(true);
  }

  hideLoading() {
    bsLoading.sink.add(false);
  }
  @override
  dispose() {
     super.dispose();
     listCoins.close();
  }
}
