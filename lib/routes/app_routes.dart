// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:korat/routes/web_routes.dart';

class AppRoute {
  static AppRoute? _instance;

  factory AppRoute() => _instance ??= AppRoute._();

  AppRoute._() {
    _routes = WebRoute.routes();
    // if (kIsWeb) {
    //   _routes = WebRoute.routes();
    // } else {
    //   _routes = MobileRoute.routes();
    // }
  }

  static AppRoute sharedInstance() {
    if (_instance == null) {
      _instance = AppRoute._();
    }
    return _instance!;
  }

  Route generatedRoutes(RouteSettings settings) {
    return WebRoute.getRoute(settings);
    // if (kIsWeb) {
    //   return WebRoute.getRoute(settings);
    // } else {
    //   return MobileRoute.getRoute(settings);
    // }
  }

  Map<String, WidgetBuilder>? _routes;
  get routes => _routes;
  static const String initialRoute = home;

  static const String home = '/';
  static const String post = '/post';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String publish_report = '/publish_report';
  static const String project_editor = '/project_editor';
  static const String project_list = '/project_list';
  static const String project_settings = '/project_settings';
  static const String report = '/report';
}
