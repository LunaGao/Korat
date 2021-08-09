import 'package:flutter/material.dart';
import 'package:korat/pages/add_platform/platform_add_aliyun_oss.dart';
import 'package:korat/pages/dashboard/dashboard.dart';
import 'package:korat/pages/public/error.dart';
import 'package:korat/pages/public/home.dart';
import 'package:korat/pages/signin/signin.dart';
import 'package:korat/pages/signup/signup.dart';
import 'app_routes.dart';

class WebRoute {
  static Map<String, WidgetBuilder> routes() {
    return {
      AppRoute.home: (context) => HomePage(),
      AppRoute.signin: (context) => SignInPage(),
      AppRoute.signup: (context) => SignUpPage(),
      AppRoute.dashboard: (context) => DashBoardPage(),
      AppRoute.platform_add_aliyun_oss: (context) => PlatformAddAliyunOSSPage(),
    };
  }

  static Route getRoute(RouteSettings settings) {
    // if (settings.name!.contains(AppRoute.project)) {
    //   var value = settings.name!.replaceAll(AppRoute.project, '');
    //   return MaterialPageRoute(
    //     builder: (context) => ProjectDetailPage(
    //       projectName: value,
    //     ),
    //     settings: settings,
    //   );
    // }
    // if (settings.name!.contains(AppRoute.versionUse)) {
    //   var value = settings.name!.replaceAll(AppRoute.versionUse, '');
    //   return MaterialPageRoute(
    //     builder: (context) => VersionUsePage(
    //       projectName: value,
    //     ),
    //     settings: settings,
    //   );
    // }
    return MaterialPageRoute(
      builder: (context) => ErrorPage(),
      settings: settings,
    );
  }
}
