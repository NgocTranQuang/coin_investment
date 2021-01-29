import 'package:json_annotation/json_annotation.dart';

part 'coin_price.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class CoinPrice {
   String price;
   String symbol;
  List<CoinPrice> listChild;

  CoinPrice({this.price, this.symbol,this.listChild});

  factory CoinPrice.fromJson(Map<String, dynamic> json) =>
      _$CoinPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CoinPriceToJson(this);

  @override
  String toString() {
    return symbol;
  }
}

