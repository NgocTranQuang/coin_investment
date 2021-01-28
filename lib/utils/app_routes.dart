import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_investment/pages/creenb/bpage.dart';
import 'package:my_investment/pages/home/home_page.dart';
import 'package:my_investment/pages/sceena/apage.dart';

class AppRoutes {
  static dynamic generateRoute(RouteSettings routeSetting) {
    return CupertinoPageRoute(builder: (context) {
      switch (routeSetting.name) {
        case HomePage.pageName:
          {
            return HomePage("Home Page");
          }
        case APage.pageName:
          {
            return APage("A Page");
          }
        case BPage.pageName:{
          return BPage("B Page");
        }
      }
      return APage("Page A");
    });
  }
}
