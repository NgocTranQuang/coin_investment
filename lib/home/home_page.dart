import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/extension/base_state_less_ex.dart';
import 'package:my_investment/home/home_cubit.dart';
import 'package:my_investment/home/row.dart';
import 'package:my_investment/model/coin_model.dart';

class HomePage extends BaseStatelessWidget<HomeCubit> {
  // final String title;
  static final String pageName = "HomePage";

  HomePage(String title) : super(title);

  static push(BuildContext context) {
    Navigator.pushNamed(context, HomePage.pageName);
  }

  @override
  initState() {
    cubit.getListCoin();
  }

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
                  return RowCoin(snapshot.data[index]);
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
