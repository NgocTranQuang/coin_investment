import 'package:my_investment/enum/enum_app.dart';

class MessageEventBus{
  final EvenBusType type;
  final dynamic data;

  MessageEventBus(this.type, this.data);
}