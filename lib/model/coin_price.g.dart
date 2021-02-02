// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinPrice _$CoinPriceFromJson(Map<String, dynamic> json) {
  return CoinPrice(
    askPrice: json['bidPrice'] as String,
    symbol: json['symbol'] as String,
    symbolNode: json['symbolNode'] as String,
    amount: json['amount'] as double,
    listChild: (json['listChild'] as List)
        ?.map((e) =>
            e == null ? null : CoinPrice.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CoinPriceToJson(CoinPrice instance) => <String, dynamic>{
      'bidPrice': instance.askPrice,
      'symbol': instance.symbol,
      'listChild': instance.listChild,
      'symbolNode': instance.symbolNode,
      'amount': instance.amount,
    };
