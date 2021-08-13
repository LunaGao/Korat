import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/user_api.dart';

class DashboardDivider extends StatelessWidget {
  const DashboardDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: VerticalDivider(
        width: 1,
      ),
    );
  }
}

class EmailNotVerifiedWidget extends StatelessWidget {
  final User user;
  const EmailNotVerifiedWidget(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return user.emailVerified
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
                    UserApi().requestEmailVerify(user.email).then((value) {
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
}
