import 'package:flutter/material.dart';
import 'package:my_investment/extension/double_ex.dart';
import 'package:my_investment/model/coin_model.dart';
import 'package:my_investment/utils/image_name_util.dart';

class RowCoin extends StatelessWidget {
  final CoinModel coinModel;

  const RowCoin(this.coinModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: coinModel.color,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 1, child: common1()),
                SizedBox(
                  width: 8,
                ),
                Expanded(flex: 1, child: common2()),
                SizedBox(
                  width: 8,
                ),
                // Expanded(flex: 1, child: common3()),
              ],
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }

  Widget common1() {
    return Column(
      children: [
        Text(coinModel.symbol),
        SizedBox(
          height: 4,
        ),
        Image.asset(
          ImageName.bitcoin,
          width: 40,
          height: 40,
        )
      ],
    );
  }

  Widget common2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Price usdt :${coinModel.priceBuy}"),
        Text("Price busd :${coinModel.priceNow}"),
        Text("Hieu : ${coinModel.amount}"),
      ],
    );
  }

  Widget common3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Interest :${coinModel.interestRatePercent.toStringAsFixed(2)} %"),
        Text("Interest :${coinModel.interestRateCurrency.toPrice()}"),
      ],
    );
  }
}
