import 'package:flutter/material.dart';

class CoinModel {
  String symbol;
  String name;
  double priceBuy;
  double priceNow;
  double amount;
}

extension coinPlus on CoinModel {
  double get interestRatePercent {
    var totalBuy = amount * priceBuy;
    double s = (interestRateCurrency / totalBuy) * 100;
    return s;
  }

  double get interestRateCurrency {
    double totalBuy = amount * priceBuy;
    double totalNow = amount * priceNow;
    return totalNow - totalBuy;
  }

  Color get color {
    var interestRatePercentNumber = interestRatePercent;
    if (interestRatePercentNumber < -50) {
      return Colors.red;
    }
    if (interestRatePercentNumber < 0) {
      return Colors.orangeAccent;
    }
    if (interestRatePercentNumber < 30) {
      return Colors.lightGreenAccent;
    }
    if (interestRatePercentNumber < 50) {
      return Colors.greenAccent;
    }
    if (interestRatePercentNumber < 100) {
      return Colors.lightGreen;
    }
    return Colors.green;
  }
}
