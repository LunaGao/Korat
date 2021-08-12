import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/post.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';
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
  PlatformModel platformModel = PlatformModel();
  String email = '';
  var oss;
  List<Post> posts = [];
  String displayValue = '';
  TextEditingController textEditingController = TextEditingController();

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
      } else {
        var platformJson = platformResponse.message['results'][0];
        if (platformJson['platform'] == PlatformConfig.aliyunOSS) {
          platformModel.platform = platformJson['platform'];
          platformModel.endPoint = platformJson['endPoint'];
          platformModel.keyId = platformJson['keyId'];
          platformModel.keySecret = platformJson['keySecret'];
          platformModel.bucket = platformJson['bucket'];
          oss = AliyunOSSClient(
            platformModel.keyId,
            platformModel.keySecret,
            platformModel.endPoint,
            platformModel.bucket,
          );
          var result = await oss.listObjects();
          if (result.isSuccess) {
            posts = result.message;
          } else {
            print(result.errorMessage);
          }
        }
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
            Text("    " + platformModel.bucket),
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
        emailNotVerifiedWidget(),
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

  Widget emailNotVerifiedWidget() {
    return emailVerified
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
          );
  }

  Widget platformWidget() {
    return Row(
      children: [
        Container(
          width: 200,
          child: Column(
            children: [
              ...postListWidget(),
              TextButton(
                onPressed: () async {
                  var result = await oss.putObject();
                  if (result.isSuccess) {
                    print(result.message);
                  } else {
                    print(result.errorMessage);
                  }
                },
                child: Text("创建帖子"),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: textEditingController,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Markdown(
            shrinkWrap: true,
            data: displayValue,
          ),
        ),
      ],
    );
  }

  List<Widget> postListWidget() {
    List<Widget> returnValue = [];
    for (var post in posts) {
      var postItem = TextButton(
        onPressed: () async {
          ResponseModel<Post> responseModel = await oss.getObject(post);
          if (responseModel.isSuccess) {
            displayValue = responseModel.message!.value;
          } else {
            displayValue = responseModel.errorMessage;
          }
          textEditingController.text = displayValue;
          setState(() {});
        },
        child: Text(post.displayFileName),
      );
      returnValue.add(postItem);
    }
    return returnValue;
  }
}
