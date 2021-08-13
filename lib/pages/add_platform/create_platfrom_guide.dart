import 'package:flutter/material.dart';
import 'package:korat/routes/app_routes.dart';

class CreatePlatformGuidePage extends StatefulWidget {
  const CreatePlatformGuidePage({Key? key}) : super(key: key);

  @override
  _CreatePlatformGuidePageState createState() =>
      _CreatePlatformGuidePageState();
}

class _CreatePlatformGuidePageState extends State<CreatePlatformGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请配置博客数据文件存储平台"),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.platform_add_aliyun_oss);
            },
            child: Text("Aliyun oss"),
          ),
        ],
      ),
    );
  }
}
