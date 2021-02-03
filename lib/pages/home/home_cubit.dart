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
  BehaviorSubject<bool> isOnTop = BehaviorSubject.seeded(true);
  BehaviorSubject<List<FinalResult>> listCoinsFinalResult = BehaviorSubject();
  var a = List<CoinModel>();
  var size = all_coin.length;

  var listAllPrice = List<CoinPrice>();
  var usdt = CoinPrice(
      amount: 1000,
      askPrice: "1",
      symbol: "USDT",
      symbolNode: "USDT",
      level: 0);
  var listNoded = List<String>();

  var listCoinName = List<String>();

  var listFinalWithUSDT = List<CoinPrice>();
  var listRoad = List<FinalResult>();

  //////////////
  getListCoinChenhLechGia() async {
    // tìm tất cả các đồng tiền đi với USDT
    await heueu().then((value) {});
    await Future.delayed(Duration(seconds: 5));
    calculator();
  }

  Future<String> heueu() async {
    findAllSymbolsWithASYNC(usdt, true).then((value) async {
      usdt.listChild = value;
      if(value!=null) {
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
      }
    }).then((value) {
      return "";
    });
  }

  void calculator() {
    listFinalWithUSDT.sort((a, b) {
      var checLechB = (b.amount - 1000);
      if (checLechB < 0) {
        checLechB = checLechB * -1;
      }
      var checLechA = (a.amount - 1000);
      if (checLechA < 0) {
        checLechA = checLechA * -1;
      }
      return checLechB.compareTo(checLechA);
    });

    print("Bắt đầu show ${listFinalWithUSDT.length} kết quả");
    forListWithAndDoSomeThing(listFinalWithUSDT, (element) async {
      listRoad.add(handleRoadMap(element, FinalResult()));
    }).then((value) {
      listCoinsFinalResult.sink.add(listRoad);
      hideLoading();
    });
  }

  FinalResult handleRoadMap(CoinPrice coinPrice, FinalResult itemRs) {
    var startName = "";
    var startAmount = "";
    var startPrice = "";
    if (itemRs.roadName != null) {
      startName = "${itemRs.roadName} -> ";
    }
    if (itemRs.roadAmount != null) {
      startAmount = "${itemRs.roadAmount} -> ";
    }
    if (itemRs.roadPrice != null) {
      startPrice = "${itemRs.roadPrice} -> ";
    }
    itemRs.roadName = "${startName}${coinPrice.symbolNode}";
    itemRs.roadAmount = "${startAmount}${coinPrice.amount}";
    itemRs.roadPrice = "${startPrice}${coinPrice.tradeWithPrice}";

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
        String priceToTrade;
        if(coinPrice.level%2 ==0){
          // level coin hiện tại là lẻ
          //đang mua => dựa vào giá bán =>bid price
          priceToTrade = e.bidPrice;
        }else{
          // đang bán coin => dựa vào giá mua => ask price
          priceToTrade = e.askPrice;
        }

        double tradeWithPrice;
        if (e.symbol.endsWith("USDT")) {
          tradeWithPrice =  double.parse(priceToTrade);
        } else {
          tradeWithPrice = (1.0/ double.parse(priceToTrade));
        }
        e.amount = coinPrice.amount * tradeWithPrice;
        e.tradeWithPrice = "$tradeWithPrice";
        e.symbolNode = "USDT";
        e.level = coinPrice.level + 1;
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
          .where((element) => ((element.symbol.startsWith(symbols) || element.symbol.endsWith(symbols)) && !element.symbol.contains(coinPrice.parent.symbolNode)))
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
        if (coinPrice.symbolNode == "BTC" && coin == "PHB") {
          print("Đến rồi");
        }
        String priceToTrade;
        if(coinPrice.level%2 ==0){
          // level coin hiện tại là lẻ
          //đang mua => dựa vào giá bán =>bid price
          priceToTrade = e.bidPrice;
        }else{
          // đang bán coin => dựa vào giá mua => ask price
          priceToTrade = e.askPrice;
        }
        double tradeWithPrice;
        if (e.symbol.endsWith(coin)) {
          tradeWithPrice =  double.parse(priceToTrade);
        } else {
          tradeWithPrice = (1.0/ double.parse(priceToTrade));
        }
        e.tradeWithPrice = "$tradeWithPrice";
        e.amount = coinPrice.amount * tradeWithPrice;
        e.symbolNode = coin;
        e.level = coinPrice.level + 1;
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
    isOnTop.close();
  }

  tenHam(int Function(String a) haha) {
    haha.call("d");
  }
}
