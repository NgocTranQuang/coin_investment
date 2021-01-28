import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_investment/base/base_cubit.dart';
import 'package:my_investment/model/coin_model.dart';
import 'package:my_investment/model/coin_price.dart';
import 'package:my_investment/utils/all_coin.dart';
import 'package:rxdart/rxdart.dart';

class HomeCubit extends BaseCubit {
  BehaviorSubject<List<CoinModel>> listCoins = BehaviorSubject();
  var a = List<CoinModel>();
  var size = all_coin.length;

  var listAllPrice = List<CoinPrice>();
  var usdt = CoinPrice(price: "1", symbol: "vkl");
  var listNoded = List<String>();

  getPrice() async {
    showLoading();
    // abc();
    fetchAllPrice().then((value) async {
      listAllPrice = value.toList();
      print("${jsonEncode(value)}");
      var a = await addAllCoupleWith("USDT", usdt);

      // var listUSDT = value.where((element) {
      //   return element.symbol.endsWith("USDT");
      // }).toList();
      //
      // listUSDT.forEach((element) {
      //   var coin = element.symbol.replaceAll("USDT", "");
      //   element.listChild = value.where((element) {
      //     return element.symbol.contains(coin);
      //   }).toList();
      // });
      // // var list2 = value.where((element) {
      // //   return element.symbol.startsWith("USDT");
      // // });
      // print(jsonEncode(listUSDT));
      hideLoading();
    });
  }

  addAllCoupleWith(
    String mainSymbols,
    CoinPrice coinPrice,
  ) {
    print("Bắt đầu tìm list chid của  ${coinPrice.symbol}");
    coinPrice.listChild = findAllCoupleWith(mainSymbols, coinPrice.symbol);
  }

  List<CoinPrice> findAllCoupleWith(String mainSymbols, String symbolsEx) {
    print("Đang chạy tìm tất cả các cặp tiền của $mainSymbols");
    var parentSymbol = symbolsEx.replaceAll(mainSymbols, "");
    return listAllPrice
        .where((element) {

          if(mainSymbols =="ETH" && parentSymbol =="BTC"){
            print("abcd");
          }
          return element.symbol.contains(mainSymbols) &&
              !element.symbol.contains(parentSymbol);
        })
        // .toList()
        // .map((e) {
        //   var coin = e.symbol.replaceAll(mainSymbols, "");
        //   print("Các cặp tiền của $mainSymbols là  ${coin}");
        //   if (coin != "") {
        //     var l = listNoded.where((element) {
        //       return element == coin;
        //     }).toList();
        //     if (l.length == 0) {
        //       if (coin != "USDT") {
        //         listNoded.add(coin);
        //       }
        //       addAllCoupleWith(coin, e);
        //     } else {
        //       e.listChild = listAllPrice
        //               .where((element) =>
        //                   (element.symbol.contains("USDT$mainSymbols") ||
        //                       element.symbol.contains("${mainSymbols}USDT")))
        //               .toList() ??
        //           List<CoinPrice>.generate(1, (index) => CoinPrice(price :"1", symbol: "Ko co USDT$mainSymbols hoặc ${mainSymbols}USDT"));
        //     }
        //   }
        //   return e;
        // })
        .toList();
  }

  abc() {
    for (var element in all_coin) {
      fetchPriceWithUSDT(element).then((valueUSDT) {
        fetchPriceWithBUSD(element).then((valueBUSD) {
          CoinModel coin = CoinModel();
          coin.symbol = "${valueUSDT.symbol} ?? null";
          coin.priceBuy = double.parse(valueUSDT.price ?? -1);
          coin.priceNow = double.parse(valueBUSD.price ?? -1);
          coin.amount = coin.priceBuy - coin.priceNow;
          a.add(coin);
          if (a.length == size) {
            listCoins.sink.add(a);
            hideLoading();
          }
        });
      });
    }
  }

  Future<List<CoinPrice>> fetchAllPrice() async {
    final response =
        await http.get('https://www.binance.com/api/v1/ticker/allPrices');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Request all price ngon lành");
      var json = jsonDecode(response.body);
      List<CoinPrice> list =
          List<CoinPrice>.from(json.map((model) => CoinPrice.fromJson(model)));

      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Request all price thất bại ${response.statusCode}");
      return null;
    }
  }

  Future<CoinPrice> fetchPrice(String symbol, String symbol2) async {
    final response = await http.get(
        'https://api.binance.com/api/v3/ticker/price?symbol=${symbol}${symbol2}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Request $symbol ngon lành");
      return CoinPrice.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Request $symbol/$symbol2 thất bại ${response.statusCode}");
      return null;
    }
  }

  Future<CoinPrice> fetchPriceWithUSDT(String symbol) async {
    return fetchPrice(symbol, "USDT");
  }

  Future<CoinPrice> fetchPriceWithBUSD(String symbol) async {
    return fetchPrice(symbol, "BUSD");
  }

  @override
  dispose() {
    super.dispose();
    listCoins.close();
  }

  tenHam(int Function(String a) haha) {
    haha.call("d");
  }
}
