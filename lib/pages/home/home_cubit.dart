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
  var usdt = CoinPrice(
      amount: 1000, bidPrice: "1", symbol: "USDT", symbolNode: "USDT");
  var listNoded = List<String>();

  var listCoinName = List<String>();

  finListCoinName() {
    listNoded.add("USDT");
    listAllPrice.forEach((element) {
      listCoinName.forEach((coin) {
        if (element.symbol.contains(coin)) {}
      });
    });
  }

  //////////////
  newVersion() {
    // tìm tất cả các đồng tiền đi với USDT

    // var listWithUSDT = findAllSymbolsWith(usdt, true);
    findAllSymbolsWithASYNC(usdt, true).then((value) async {
      value.forEach((element) {
        print("DKM foreach ${element.symbol}");
        element.listChild = findAllSymbolsWith(element, false);
      });
    });
    // listWithUSDT.forEach((element) {
    //   element.listChild = findAllSymbolsWith(element, false);
    // });
    print("object");

    // listWithUSDT.forEach((element) {
    //   // element.listChild =
    // });
    // listWithUSDT.forEach((element) {
    //   element.listChild.forEach((element) {});
    // });
    // tìm tất cả những đồng tiền của những đồng tiền đi với usdt
    // listWithUSDT.forEach((element) {
    //   element.listChild = findAllSymbolsWith(element.symbol);
    // });
    // listWithUSDT.forEach((element) {
    //   element.listChild.forEach((element) {});
    // });
  }

  Future forListWithAndDoSomeThing(
      List<CoinPrice> list, Function(CoinPrice element) fun) async {
    for (final element in list) {
      fun.call(element);
    }
  }

  Future forListAndSetListChild(List<CoinPrice> list) async {
    forListWithAndDoSomeThing(list, (element) {
      // element.listChild = findAllSymbolsWith(element.symbol);
    });
  }

  Future<List<CoinPrice>> findAllSymbolsWithASYNC(
      CoinPrice coinPrice, bool start) async {
    return findAllSymbolsWith(coinPrice, start);
  }

  List<CoinPrice> findAllSymbolsWith(CoinPrice coinPrice, bool start) {
    print(
        "************************ bắt đầu tìm list child cho ${coinPrice.toString()}");
    var symbols = coinPrice.symbolNode;
    if (symbols == "" || symbols == null) {
      print("DKM symbols bằng null");
      return null;
    }
    if (start == false) {
      if (symbols == "USDT") {
        return null;
      }
    }
    var listWithSymbol = listAllPrice
        .where((element) => ((element.symbol.startsWith(symbols) ||
            element.symbol.endsWith(symbols))))
        .toList();
    print("Coin $symbols có ${listWithSymbol.length} thằng coin con cặp với nó");
    return listWithSymbol.map((ele) {
      var e = CoinPrice(
          symbol: ele.symbol,
          amount: ele.amount,
          bidPrice: ele.bidPrice,
          symbolNode: ele.symbolNode,
          listChild: ele.listChild);
      print("------------------------");
      var coin = e.symbol.replaceAll(symbols, "");
      print("Bắt đầu xét thằng ${coin}");
      // vì điều kiện where như vậy chưa chắc là lấy đúng những đồng coin có đi cặp với symbols,nên ở đây cần phải check đồng coin đó có dc giao dịch với btc nữa hay ko
      if (coin != "BTC") {
        var listWithBtc = listAllPrice
            .where((element) => (element.symbol == "${coin}BTC" ||
                element.symbol == "BTC${coin}"))
            .toList();
        if (listWithBtc.length == 0) {
          print("Đồng ${coin} này méo dc giao dịch với BTC");
          return CoinPrice();
        }
      }
      if (listNoded.contains(coin) || coin == "") {
        print("Coin $coin này đã có trong node");
        // coin này đã có trong node
        // lấy cặp symbol với USDT
        var list = listAllPrice
            .where((element) => (element.symbol == "${symbols}USDT" ||
                element.symbol == "USDT${symbols}"))
            .toList();
        if ((list?.length ?? 0) == 0) {
          print("DKM $symbols ko có cặp với usdt ${list.length}");
          return CoinPrice();
        } else if ((list.length ?? 0) == 1) {
          e = list.first;
        } else {
          print("DKM nó có leng khác 0 với 1 ${list.length}");
          return null;
        }
      } else {
        listNoded.add(coin);
        print("Add $coin vào node");
        if (e.symbol.endsWith(coin)) {
          e.amount = coinPrice.amount * double.parse(e.bidPrice);
        } else {
          e.amount = coinPrice.amount * (1.0 / double.parse(e.bidPrice));
        }
      }
      e.symbolNode = coin;
      print("Liên kết mới : ${coinPrice.amount.toStringAsFixed(3)} ${symbols} =  ${e.amount.toStringAsFixed(3)} ${e.symbolNode}");
      print("Kết thúc xét thằng coin ${e.symbolNode} => Thêm vào list child");
      print("------------------------");
      return e;
    }).toList();
  }

  ///////////////

  getPrice() async {
    showLoading();
    // abc();
    fetchAllPrice().then((value) async {
      listAllPrice = value.toList();
      listAllPrice = listAllPrice
          .where((element) => double.parse(element.bidPrice) != 0)
          .toList();
      print("${jsonEncode(value)}");
      newVersion();

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
    return listAllPrice.where((element) {
      if (mainSymbols == "ETH" && parentSymbol == "BTC") {
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
          coin.priceBuy = double.parse(valueUSDT.bidPrice ?? -1);
          coin.priceNow = double.parse(valueBUSD.bidPrice ?? -1);
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
        await http.get('https://www.binance.com/api/v1/ticker/allBookTickers');

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
