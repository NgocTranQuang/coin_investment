import 'package:my_investment/base/base_cubit.dart';
import 'package:my_investment/base/base_stateless_widget.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

extension BaseStatelessWidgetEX<T extends BaseCubit> on BaseStatelessWidget<T> {
  T get cubit {
    return currentContext.cubit<T>();
  }
}
