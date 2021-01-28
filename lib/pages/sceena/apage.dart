import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/enum/enum_app.dart';
import 'package:my_investment/pages/creenb/bpage.dart';
import 'package:my_investment/pages/sceena/cubita.dart';
import 'package:my_investment/utils/event_bus.dart';

class APage extends BaseStatelessWidget<CubitA> {
  static const String pageName = "A";

  APage(String title) : super(title);

  static push(BuildContext context) {
    Navigator.pushNamed(context, APage.pageName);
  }

  @override
  initState() {}

  @override
  Subscription subscribeEvents(EventBus eventBus) {
   return eventBus.respond<int>((event) {
      print("Nhận push $runtimeType");
      cubit.count.sink.add(event);
    });
  }

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            MyStreamBuilder<int>(
                stream: cubit.count.stream,
                builder: (context, snapshot) {
                  return Text("${snapshot.data}");
                }),
            FlatButton(
                onPressed: () {
                  BPage.push(context);
                },
                child: Text("Go to page B"))
          ],
        ),
      ),
    );
  }

  @override
  CubitA getCubit() {
    return CubitA();
  }
}
