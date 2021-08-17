import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformAddAliyunOSSPage extends StatefulWidget {
  const PlatformAddAliyunOSSPage({Key? key}) : super(key: key);

  @override
  _PlatformAddAliyunOSSPageState createState() =>
      _PlatformAddAliyunOSSPageState();
}

class _PlatformAddAliyunOSSPageState extends State<PlatformAddAliyunOSSPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String endpoint = "";
  String bucket = "";
  String accessKeyId = "";
  String accessKeySecret = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("添加阿里云oss平台"),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("https://help.aliyun.com/document_detail/31837.htm"),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'endpoint',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'endpoint';
                    }
                    endpoint = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'bucket',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'bucket';
                    }
                    bucket = value;
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'accessKeyId',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'accessKeyId';
                    }
                    accessKeyId = value;
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'accessKeySecret',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'accessKeySecret';
                    }
                    accessKeySecret = value;
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show(status: '请求中...');
                        SharedPreferences.getInstance().then((prefs) {
                          var currentUserId = prefs.getString('currentUserId')!;
                          PlatformApi()
                              .postAliyunOSSPlatform(
                            endpoint,
                            bucket,
                            accessKeyId,
                            accessKeySecret,
                            currentUserId,
                          )
                              .then((value) {
                            EasyLoading.dismiss();
                            if (value.isSuccess) {
                              EasyLoading.showSuccess('添加成功');
                              Navigator.of(context).pop();
                            } else {
                              EasyLoading.showError(value.errorMessage);
                            }
                          });
                        });
                      }
                    },
                    child: const Text(
                      '添加',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
