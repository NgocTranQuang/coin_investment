import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(this.name, this.email);

  String name;
  String email;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class CoinPrice {
  final String price;
  final String symbol;

  CoinPrice({this.price, this.symbol});

  factory CoinPrice.fromJson(Map<String, dynamic> json) {
    return CoinPrice(
      price: json['price'] as String,
      symbol: json['symbol'] as String,
    );
  }
  Map<String, dynamic> toJson() => {'price': price, 'symbol': symbol};
}
