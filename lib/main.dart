import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/common/global.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: 'Korat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Alibaba',
        platform: TargetPlatform.android, //NOTE: 用来禁用滑动返回的。
      ),
      initialRoute: AppRoute.initialRoute,
      routes: AppRoute.sharedInstance().routes,
      onGenerateRoute: AppRoute.sharedInstance().generatedRoutes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // This is required
      ],
      supportedLocales: [
        Locale('zh', ''),
      ],
    );
  }
}
