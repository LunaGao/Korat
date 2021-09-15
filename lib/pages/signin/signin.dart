import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/common/global.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  signIn() async {
    await EasyLoading.show(status: '请求中...');
    var value = await UserApi().signin(email, password);
    await EasyLoading.dismiss();
    if (value.isSuccess) {
      await Global.signin(
        value.message['sessionToken'],
      );
      Navigator.of(context).pop();
    } else {
      await EasyLoading.showError(value.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("登录"),
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
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '输入邮箱地址',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱地址';
                    }
                    email = value;
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '输入密码',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    password = value;
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        this.signIn();
                      }
                    },
                    child: const Text(
                      '登录',
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
