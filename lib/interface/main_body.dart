import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IMainBody{
  initState();
  dispose();
  Widget getBody(BuildContext context);
  PreferredSize getAppBar(BuildContext context);
  FloatingActionButton getFloatButton(BuildContext context);
}