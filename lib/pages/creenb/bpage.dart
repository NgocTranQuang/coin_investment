import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/enum/enum_app.dart';
import 'package:my_investment/pages/sceena/cubita.dart';
import 'package:my_investment/utils/event_bus.dart';

class BPage extends BaseStatelessWidget<CubitA> {
  static const String pageName = "B";

  BPage(String title) : super(title);

  static push(BuildContext context) {
    Navigator.pushNamed(context, BPage.pageName);
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
                  eventBus.publish(snapshot.data);
                  return Text("${snapshot.data}");
                }),
            FlatButton(
                onPressed: () {
                  cubit.congLen();
                },
                child: Text("Cộng lên"))
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
