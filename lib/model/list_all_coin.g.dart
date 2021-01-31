// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_all_coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAllCoin _$ListAllCoinFromJson(Map<String, dynamic> json) {
  return ListAllCoin(
    listAll: (json['listAll'] as List)
        ?.map((e) =>
            e == null ? null : CoinPrice.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListAllCoinToJson(ListAllCoin instance) =>
    <String, dynamic>{
      'listAll': instance.listAll,
    };
