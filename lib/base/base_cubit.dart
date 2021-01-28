import 'package:cubit/cubit.dart';
import 'package:rxdart/rxdart.dart';

class BaseCubit extends Cubit<bool> {
  BaseCubit() : super(false){
    print("init cubit $runtimeType ${identityHashCode(this)}");
  }
  BehaviorSubject<bool> bsLoading = BehaviorSubject<bool>();
  BehaviorSubject<bool> bsRefresh = BehaviorSubject<bool>();

  dispose() {
    bsLoading.close();
    bsRefresh.close();
    print("close cubit $runtimeType ${identityHashCode(this)}");
  }

  
  showLoading() {
    bsLoading.sink.add(true);
  }

  hideLoading() {
    bsLoading.sink.add(false);
  }
}
