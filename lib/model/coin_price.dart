import 'package:json_annotation/json_annotation.dart';

part 'coin_price.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class CoinPrice {
  String bidPrice;
  String askPrice;
  String symbol;
  double amount;
  List<CoinPrice> listChild;
  String symbolNode;

  CoinPrice(
      {this.askPrice,
      this.bidPrice,
      this.symbol,
      this.amount,
      this.symbolNode,
      this.level,
      this.listChild});

  factory CoinPrice.fromJson(Map<String, dynamic> json) =>
      _$CoinPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CoinPriceToJson(this);

  @override
  String toString() {
    return "Name: $symbolNode | Amount : $amount | full node(${symbol})";
  }

  CoinPrice copy() {
    return CoinPrice(
        askPrice: this.askPrice,
        bidPrice: this.bidPrice,
        symbol: this.symbol,
        symbolNode: this.symbolNode,
        listChild: this.listChild);
  }

  CoinPrice parent;
  int level;
  String tradeWithPrice;
}
