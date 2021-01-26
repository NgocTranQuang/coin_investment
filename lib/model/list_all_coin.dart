import 'package:json_annotation/json_annotation.dart';
import 'package:my_investment/model/coin_price.dart';
part 'list_all_coin.g.dart';


@JsonSerializable()
class ListAllCoin{
   List<CoinPrice> listAll ;
   ListAllCoin({this.listAll});

   factory ListAllCoin.fromJson(Map<String, dynamic> json) =>
       _$ListAllCoinFromJson(json);

   Map<String, dynamic> toJson() => _$ListAllCoinToJson(this);

}