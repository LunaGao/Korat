import 'package:flutter/material.dart';
import 'package:korat/pages/settings/widgets/common/common_settings.dart';

class UserSettingsWidget extends StatefulWidget {
  const UserSettingsWidget({Key? key}) : super(key: key);

  @override
  _UserSettingsWidgetState createState() => _UserSettingsWidgetState();
}

class _UserSettingsWidgetState extends State<UserSettingsWidget> {
  var userNameEditingController = TextEditingController();
  var userDetailEditingController = TextEditingController();

  save() {
    print("save2");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...group(
          "作者信息",
          userSettingsWidgets(),
        ),
      ],
    );
  }

  List<Widget> userSettingsWidgets() {
    return [
      inputBox("作者名字", userNameEditingController),
      inputBox("作者简介", userDetailEditingController),
      inputBox("作者头像", userDetailEditingController),
      saveButton(save),
    ];
  }
}
