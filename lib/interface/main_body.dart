import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_bus/flutter_event_bus/EventBus.dart';
import 'package:flutter_event_bus/flutter_event_bus/Subscription.dart';

abstract class IMainBody {
  buildContext(BuildContext context);
  initState();
  dispose();
  didChangeDependencies();
  Widget getBody(BuildContext context);
  PreferredSize getAppBar(BuildContext context);
  FloatingActionButton getFloatButton(BuildContext context);
  Subscription subscribeEvents(EventBus eventBus);
}
