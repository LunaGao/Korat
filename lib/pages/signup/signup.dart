import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/routes/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("注册"),
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
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '确认输入密码',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '请再次输入密码';
                    }
                    if (password != value) {
                      return '两次密码不一致';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show(status: '请求中...');
                        UserApi().signup(email, password).then((value) {
                          EasyLoading.dismiss();
                          if (value.isSuccess) {
                            EasyLoading.showSuccess('注册成功，请登录');
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoute.signin);
                          } else {
                            EasyLoading.showError(value.errorMessage);
                          }
                        });
                      }
                    },
                    child: const Text(
                      '注册',
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
