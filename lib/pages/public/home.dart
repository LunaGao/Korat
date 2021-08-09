import 'package:flutter/material.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUserSignin = false;

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('sessionToken');
    if (sessionToken == null) {
      isUserSignin = false;
    } else {
      isUserSignin = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Korat"),
          ],
        ),
        actions: [
          isUserSignin
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoute.signup);
                  },
                  child: Text(
                    "注册",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          isUserSignin
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoute.signin);
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          isUserSignin
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.dashboard);
                  },
                  child: Text(
                    "控制台",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
