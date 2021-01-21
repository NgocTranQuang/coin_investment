import 'package:flutter/material.dart';
import 'package:my_investment/custom_widget/custom_widget.dart';

// ignore: must_be_immutable
class MyStreamBuilder<T> extends StreamBuilder<T> {
  MyStreamBuilder({
    Key key,
    T initialData,
    Widget widgetWhenNull,
    Stream<T> stream,
    @required AsyncWidgetBuilder<T> builder,
  })  : assert(builder != null),
        super(
          key: key,
          stream: stream,
          initialData: initialData,
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return builder(context, snapShot);
            } else {
              return widgetWhenNull ?? EmptyWidget();
            }
          },
        );
}
