import 'package:flutter/material.dart';
import 'package:my_investment/utils/image_name_util.dart';

class EmptyWidget extends SizedBox {
  final Key key;
  EmptyWidget({this.key}) : super(key: key,height: 0, width: 0);
}

Widget loadingWidget(BuildContext context, bool isShow) {
  return isShow
      ? Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(ImageName.icon_loading, width: 80, height: 80,),
      ))
      : EmptyWidget();
}