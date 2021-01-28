import 'package:my_investment/base/base_cubit.dart';
import 'package:rxdart/rxdart.dart';

class CubitA extends BaseCubit{
  BehaviorSubject<int> count = BehaviorSubject.seeded(0);
  @override
  dispose() {
    count.close();
    super.dispose();
  }

  void congLen() {
    count.sink.add(count.value +1);
  }

}