import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/model/final_result.dart';
import 'package:my_investment/pages/home/home_cubit.dart';
import 'package:my_investment/pages/home/row_result_price.dart';

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
    cubit.getPrice();
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

    return MyStreamBuilder<List<FinalResult>>(
        stream: cubit.listCoinsFinalResult.stream,
        builder: (context, snapshot) {
          return Center(
            child: RefreshIndicator(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data[index];
                    return RowResultPrice(finalResult: item);
                  }),
              // ignore: missing_return
              onRefresh: (){
              return cubit.getPrice();
              },
            ),
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
