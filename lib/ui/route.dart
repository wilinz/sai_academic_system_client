import 'package:flutter/cupertino.dart';
import 'package:flutter_template/ui/page/admin/admin_home.dart';

import 'page/login/login.dart';
import 'page/main/main.dart';
import 'page/splash/splash.dart';


class AppRoute {
  static String currentPage = splashPage;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String loginPage = "loginPage";

  static const String splashPage = "/";

  static const String mainPage = "mainPage";

  static const String adminHomePage = "adminHomePage";
  // static const String settingPage = "settingPage";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) {
      final args = ModalRoute.of(context)!.settings.arguments!;
      final popUpAfterSuccess = args as bool;
      return LoginPage(popUpAfterSuccess: popUpAfterSuccess);
    },
    splashPage: (context) => const SplashPage(),
    mainPage: (context) => MainPage(),
    // settingPage: (context) => SettingsPage(),
    adminHomePage: (context) => AdminHomePage()
  };
}
