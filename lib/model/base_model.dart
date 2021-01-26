class BaseModel{
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  ///
  // factory A.fromJson(Map<String, dynamic> json) => _$AFromJson(json);
  // Map<String, dynamic> toJson() => _$AToJson(this);
}