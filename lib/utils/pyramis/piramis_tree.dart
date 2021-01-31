import 'package:my_investment/model/coin_price.dart';

class PyramisTree {
  CoinPrice rootTree;

  PyramisTree() {
    rootTree = CoinPrice(symbol: "USDT");
  }
  insertNoteWithRoot(List<CoinPrice> tree){
    insertData(rootTree, tree);
  }

  insertData(CoinPrice note, List<CoinPrice> tree) {

    note.listChild = tree;
  }

  CoinPrice forAllCoinIntree(List<CoinPrice> list, CoinPrice coinPrice) {
    list.forEach((element) {
      if (element == coinPrice) {
        return element;
      } else {
        return forAllCoinIntree(element.listChild, coinPrice);
      }
    });
  }
}
