import 'package:money2/money2.dart';

extension doubleEx on double {
  String toPrice() {
    final jpy = Currency.create('USD', 0, symbol: '\$', pattern: 'S0');
    var costPrice = Money.fromInt(this.toInt(), jpy);
    return costPrice.format('S###,###.000');
  }

  String toFormat2D() {
    final jpy = Currency.create('USD', 0, symbol: '\$', pattern: 'S0');
    var costPrice = Money.fromInt(this.toInt(), jpy);
    return costPrice.format('###,###.000');
  }
}
