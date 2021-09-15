import 'package:flutter/material.dart';
import 'package:korat/common/global.dart';
import 'package:korat/pages/public/widgets/bottom_widget.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void updateUI() {
    if (Global.user == null) {
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoute.home,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "Korat",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "使用文档",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoute.publish_report,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "反馈列表",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          isUserSignin
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.signup)
                        .then((value) => updateUI());
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
                    Navigator.of(context)
                        .pushNamed(AppRoute.signin)
                        .then((value) => updateUI());
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signin_button,
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
      body: homeContent(),
    );
  }

  Widget homeContent() {
    return ListView(
      children: <Widget>[
        Container(
          height: 600,
          color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Korat      ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 90,
                  ),
                ),
                Text(
                  '     博客编辑器',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.signup)
                        .then((value) => updateUI());
                  },
                  child: Text(
                    "免费开始",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        itemContent([
          '只需要一个域名',
          '您就可以轻松的创建一个完全属于您自己的博客',
        ]),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Divider(),
        ),
        itemContent([
          '所有的博客数据',
          '均存储在 您自己的【对象存储】空间中',
        ]),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Divider(),
        ),
        Container(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 50,
                ),
                child: Text(
                  '支持平台',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/aliyun_oss.png",
                          width: 40,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '阿里云 对象存储OSS',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '增加中···',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        HomeBottomWidget(),
      ],
    );
  }

  Widget itemContent(List<String> values) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: values.map((e) {
            return Text(
              e,
              style: TextStyle(
                fontSize: 40,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
