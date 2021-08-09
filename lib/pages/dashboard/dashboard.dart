import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  bool loading = true;
  bool emailVerified = true;
  bool emptyPlatform = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var meResponse = await UserApi().me();
    if (!meResponse.isSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('sessionToken');
      Navigator.of(context).pushReplacementNamed(AppRoute.home);
    }
    emailVerified = meResponse.message['emailVerified'];
    email = meResponse.message['email'];
    var platformResponse =
        await PlatformApi().getMyPlatforms(meResponse.message['objectId']);
    print(platformResponse.message);
    if (platformResponse.isSuccess) {
      if (platformResponse.message['results'].length == 0) {
        emptyPlatform = true;
      }
    } else {
      EasyLoading.showError(platformResponse.errorMessage);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("操作台"),
          ],
        ),
        backwardsCompatibility: false,
        actions: [
          TextButton(
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove('sessionToken');
                prefs.remove('currentUserId');
                Navigator.of(context).pushReplacementNamed(AppRoute.home);
              });
            },
            child: Text(
              "退出",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mainBody(),
    );
  }

  Widget mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        emailVerified
            ? SizedBox()
            : Container(
                color: Colors.redAccent,
                padding: EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "您的邮箱未验证，请验证邮箱。",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        UserApi().requestEmailVerify(email).then((value) {
                          if (value.isSuccess) {
                            EasyLoading.showSuccess("邮件已重发");
                          }
                        });
                      },
                      child: Text(
                        "重新发送邮件",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        emptyPlatform ? emptyPlatformWidget() : platformWidget(),
      ],
    );
  }

  Widget emptyPlatformWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请配置博客数据文件存储平台"),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoute.platform_add_aliyun_oss)
                  .then((value) {
                getData();
              });
            },
            child: Text("Aliyun oss"),
          ),
        ],
      ),
    );
  }

  Widget platformWidget() {
    return SizedBox();
  }
}
