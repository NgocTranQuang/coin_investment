import 'package:flutter/material.dart';
import 'package:my_investment/model/final_result.dart';

class RowResultPrice extends StatelessWidget {
  final FinalResult finalResult;

  const RowResultPrice({Key key, this.finalResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${finalResult.roadName}"),
            Text("${finalResult.roadAmount}"),
          ],
        ),
      ),
    );
  }
}
