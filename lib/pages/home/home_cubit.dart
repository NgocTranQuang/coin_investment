import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_investment/base/base_cubit.dart';
import 'package:my_investment/model/coin_model.dart';
import 'package:my_investment/model/coin_price.dart';
import 'package:my_investment/model/final_result.dart';
import 'package:my_investment/utils/all_coin.dart';
import 'package:rxdart/rxdart.dart';

class HomeCubit extends BaseCubit {
  BehaviorSubject<List<CoinModel>> listCoins = BehaviorSubject();
  BehaviorSubject<List<FinalResult>> listCoinsFinalResult = BehaviorSubject();
  var a = List<CoinModel>();
  var size = all_coin.length;

  var listAllPrice = List<CoinPrice>();
  var usdt = CoinPrice(
      amount: 1000, askPrice: "1", symbol: "USDT", symbolNode: "USDT");
  var listNoded = List<String>();

  var listCoinName = List<String>();

  var listFinalWithUSDT = List<CoinPrice>();
  var listRoad = List<FinalResult>();

  //////////////
  getListCoinChenhLechGia() async {
    // tìm tất cả các đồng tiền đi với USDT
    await heueu();
    await Future.delayed(Duration(seconds: 10));
    calculator();
  }

  void heueu() {
    findAllSymbolsWithASYNC(usdt, true).then((value) async {
      usdt.listChild = value;
      for (final element in value) {
        if (element != null) {
          await findAllSymbolsWithASYNC(element, false).then((value) async {
            element.listChild = value;
            if (value != null) {
              for (final element in value) {
                if (element != null) {
                  await findAllSymbolsWithASYNC(element, false)
                      .then((value) async {
                    element.listChild = value;
                    if (value != null) {
                      for (final element in value) {
                        if (element != null) {
                          await findAllSymbolsWithASYNC(element, false)
                              .then((value) {
                            element.listChild = value;
                          });
                        }
                      }
                    }
                  });
                }
              }
            }
          });
        }
      }
    });
  }

  void calculator() {
    var i = 0;
    listFinalWithUSDT.sort((a, b) {
      return b.amount.compareTo(a.amount);
    });
    print("Bắt đầu show ${listFinalWithUSDT.length} kết quả");
    forListWithAndDoSomeThing(listFinalWithUSDT, (element) async {
      listRoad.add(handleRoadMap(element, FinalResult()));
    }).then((value) {
      listCoinsFinalResult.sink.add(listRoad);
      hideLoading();
      listRoad.forEach((element) {
        i++;
        print("${i} ############################");
        print("${element.roadName}");
        print("${element.roadAmount}");
        print("############################");
      });
    });
  }

  FinalResult handleRoadMap(CoinPrice coinPrice, FinalResult itemRs) {
    var startName = "";
    var startAmount = "";
    if (itemRs.roadName != null) {
      startName = "${itemRs.roadName} -> ";
    }
    if (itemRs.roadAmount != null) {
      startAmount = "${itemRs.roadAmount} -> ";
    }
    itemRs.roadName = "${startName}${coinPrice.symbolNode}";
    itemRs.roadAmount = "${startAmount}${coinPrice.amount}";
    if (coinPrice.parent != null) {
      return handleRoadMap(coinPrice.parent, itemRs);
    } else {
      return itemRs;
    }
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
    if (listNoded.contains(symbols)) {
      // có trong node rồi thì về với usdt chứ chi nựa
      print("$symbols đã có trong list, giờ tìm cặp $symbols với USDT nữa");
      var list = listAllPrice
          .where((element) => (element.symbol == "${symbols}USDT" ||
              element.symbol == "USDT${symbols}"))
          .toList();
      if ((list?.length ?? 0) == 0) {
        print("$symbols ko có cặp với usdt ");
        return null;
      } else if ((list.length ?? 0) == 1) {
        var e = list.first.copy();
        if (e.symbol.endsWith("USDT")) {
          e.amount = coinPrice.amount * double.parse(e.askPrice);
        } else {
          e.amount = coinPrice.amount * (1.0 / double.parse(e.askPrice));
        }
        e.symbolNode = "USDT";
        e.parent = coinPrice;
        print("Đã tìm thấy cặp $symbols USDT| ${e.toString()}");
        print(
            "Coin cha : ${coinPrice.toString()}   | coin con : ${e.toString()}");
        print(
            "Liên kết mới : ${coinPrice.amount.toStringAsFixed(3)} ${symbols} =  ${e.amount.toStringAsFixed(3)} ${e.symbolNode}");
        print("Kết thúc xét thằng coin ${e.symbolNode} => Thêm vào list child");
        print("------------------------");
        listFinalWithUSDT.add(e);
        return List<CoinPrice>.generate(1, (index) => e);
      } else {
        print("DKM nó có leng khác 0 với 1 ${list.length}");
        return null;
      }
    } else {
      listNoded.add(symbols);
      var listWithSymbol = listAllPrice
          .where((element) => ((element.symbol.startsWith(symbols) ||
              element.symbol.endsWith(symbols))))
          .toList();
      print(
          "Coin $symbols có ${listWithSymbol.length} thằng coin con cặp với nó");
      return listWithSymbol.map((ele) {
        var e = ele.copy();
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

        print("Add $coin vào node");
        if (e.symbol.endsWith(coin)) {
          e.amount = coinPrice.amount * double.parse(e.askPrice);
        } else {
          e.amount = coinPrice.amount * (1.0 / double.parse(e.askPrice));
        }
        e.symbolNode = coin;
        e.parent = coinPrice;

        print(
            "Coin cha : ${coinPrice.toString()}   | coin con : ${e.toString()}");
        print(
            "Liên kết mới : ${coinPrice.amount.toStringAsFixed(3)} ${symbols} =  ${e.amount.toStringAsFixed(3)} ${e.symbolNode}");
        print("Kết thúc xét thằng coin ${e.symbolNode} => Thêm vào list child");
        print("------------------------");
        return e;
      }).toList();
    }
  }

  ///////////////

  Future<String> getPrice() async {
    showLoading();
    fetchAllPrice().then((value) async {
      listAllPrice = value.toList();
      listAllPrice = listAllPrice
          .where((element) => double.parse(element.askPrice) != 0)
          .toList();
      await getListCoinChenhLechGia();
      return "success";
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
    listCoinsFinalResult.close();
  }

  tenHam(int Function(String a) haha) {
    haha.call("d");
  }
}
