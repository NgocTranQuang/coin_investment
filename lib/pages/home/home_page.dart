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
  bool isOnTop = true;
  final _controller = ScrollController();

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
                  controller: _controller,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data[index];
                    return RowResultPrice(key:UniqueKey(),finalResult: item);
                  }),
              // ignore: missing_return
              onRefresh: () {
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
        isOnTop = !isOnTop;
        if(isOnTop){
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }else{
          _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }
        cubit.isOnTop.sink.add(isOnTop);
      },
      child:
          StreamBuilder<bool>(
            stream: cubit.isOnTop.stream,
            builder: (context, snapshot) {
              return Icon(snapshot.data == true ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up);
            }
          ),
    );
  }

  @override
  HomeCubit getCubit() {
    return HomeCubit();
  }
}
