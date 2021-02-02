import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_event_bus/flutter_event_bus/EventBusWidget.dart';
import 'package:my_investment/pages/home/home_cubit.dart';
import 'package:my_investment/pages/home/home_page.dart';
import 'package:my_investment/pages/sceena/apage.dart';
import 'package:my_investment/utils/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
  // var home = HomeCubit();
  // home.getPrice();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: EventBusWidget(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.lightBlue[800],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage("Home page"),
          initialRoute: APage.pageName,
          onGenerateRoute: (routeSetting) {
            return AppRoutes.generateRoute(routeSetting);
          },
        ),
      ),
    );
  }
}
