import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/pages/dashboard/widgets/editor_widget.dart';
import 'package:korat/pages/dashboard/widgets/post_list_widget.dart';
import 'package:korat/pages/dashboard/widgets/preview_widget.dart';
import 'package:korat/pages/dashboard/widgets/utils_widget.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  bool loading = true;
  User user = User();
  bool emptyPlatform = false;
  PlatformModel platformModel = PlatformModel();
  AliyunOSSClient? oss;
  String displayValue = '';
  EditorController editorController = EditorController();
  PostListController postListController = PostListController();

  @override
  void initState() {
    super.initState();
    editorController.addListener((text) {
      setState(() {
        displayValue = text;
      });
    });
    postListController.addListener((text) {
      editorController.reset();
      editorController.setText(text);
      setState(() {
        displayValue = text;
      });
    });
    getData();
  }

  void getData() async {
    var meResponse = await UserApi().me();
    if (!meResponse.isSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('sessionToken');
      Navigator.of(context).pushReplacementNamed(AppRoute.home);
    }
    user = meResponse.message!;

    var platformResponse = await PlatformApi().getMyPlatforms(user.objectId);
    print(platformResponse);
    if (platformResponse.isSuccess) {
      if (platformResponse.message['results'].length == 0) {
        Navigator.of(context).pushNamed(AppRoute.create_platform_guide);
        return;
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
          postListController.setStorePlatform(oss!);
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
      mainAxisSize: MainAxisSize.max,
      children: [
        EmailNotVerifiedWidget(
          user,
        ),
        Expanded(
          child: platformWidget(),
        ),
      ],
    );
  }

  Widget platformWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostListWidget(
          postListController,
        ),
        DashboardDivider(),
        EditorWidget(
          editorController: editorController,
        ),
        DashboardDivider(),
        PreviewWidget(displayValue),
      ],
    );
  }
}
