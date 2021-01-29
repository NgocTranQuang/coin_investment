import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/enum/enum_app.dart';
import 'package:my_investment/model/coin_model.dart';
import 'package:my_investment/pages/home/home_cubit.dart';
import 'package:my_investment/pages/home/row.dart';
import 'package:my_investment/pages/sceena/apage.dart';
import 'package:my_investment/pages/sceena/cubita.dart';
import 'package:my_investment/utils/event_bus.dart';

// ignore: must_be_immutable
class HomePage extends BaseStatelessWidget<HomeCubit> {
  // final String title;
  static const String pageName = "HomePage";

  HomePage(String title) : super(title);

  static push(BuildContext context) {
    Navigator.pushNamed(context, HomePage.pageName);
  }

  @override
  initState() {
    cubit.newVersion();
  }

  // @override
  // Subscription subscribeEvents(EventBus eventBus) {
  //   return eventBus.respond<int>((event) {
  //     print("Nhận push $runtimeType");
  //     cubit.count.sink.add(event);
  //   });
  // }


  @override
  Widget getBody(BuildContext context) {
    print("bodyScreen");

    return MyStreamBuilder<List<CoinModel>>(
        stream: cubit.listCoins.stream,
        builder: (context, snapshot) {
          return Center(
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data[index];
                  return RowCoin(item);
                }),
          );
        });
  }

  @override
  FloatingActionButton getFloatButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        cubit.showLoading();
      },
      child: Icon(Icons.add),
    );
  }

  @override
  HomeCubit getCubit() {
    return HomeCubit();
  }
}
