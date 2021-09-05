import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/pages/settings/widgets/common/common_settings.dart';

class UserSettingsWidget extends StatefulWidget {
  final PlatformClient platformClient;
  const UserSettingsWidget(
    this.platformClient, {
    Key? key,
  }) : super(key: key);

  @override
  _UserSettingsWidgetState createState() => _UserSettingsWidgetState();
}

class _UserSettingsWidgetState extends State<UserSettingsWidget> {
  var userNameEditingController = TextEditingController();
  var userDetailEditingController = TextEditingController();
  var data = Map<String, dynamic>();
  Widget? userAvatarWidget;
  Uint8List? userAvatarFileBytes;
  String userAvatarExtension = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var response = await widget.platformClient.getObject<Map<String, dynamic>>(
      ConfigFilePath.userSettingPath,
      contentType: ContentTypeConfig.json,
    );
    if (response.isSuccess) {
      data = response.message!;
      getAndDisplayInputItem(
          SettingsConfig.userNameKey, userNameEditingController, data);
      getAndDisplayInputItem(
          SettingsConfig.userDetailKey, userDetailEditingController, data);
      getAndDisplayUserAvatarItem(SettingsConfig.userAvatarKey, data);
      setState(() {});
    } else {
      print(response.errorMessage);
      EasyLoading.showError(response.errorMessage);
    }
  }

  save() {
    var userAvatarPath = '';
    if (userAvatarFileBytes != null) {
      userAvatarPath = ConfigFilePath.imagePathPrefix +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".$userAvatarExtension";
      widget.platformClient.putObject(
        userAvatarPath,
        userAvatarFileBytes!,
        contentType: ContentTypeConfig.ico,
      );
    }
    var items = Map<String, dynamic>();
    setItem(SettingsConfig.userNameKey, userNameEditingController, items);
    setItem(SettingsConfig.userDetailKey, userDetailEditingController, items);
    setItem(SettingsConfig.blogLogoKey, null, items, value: userAvatarPath);
    widget.platformClient
        .putObject(
      ConfigFilePath.userSettingPath,
      jsonEncode(items),
      contentType: ContentTypeConfig.json,
    )
        .then((value) {
      EasyLoading.showSuccess("保存成功");
    });
  }

  onUploadUserAvatarLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
      ],
    );

    if (result != null) {
      userAvatarExtension = result.files.first.extension!;
      userAvatarFileBytes = result.files.first.bytes;
      userAvatarWidget = Image.memory(
        userAvatarFileBytes!,
        width: 60,
        height: 60,
      );
      setState(() {});
    } else {
      print("cancel");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...group(
          "作者信息",
          [
            inputBox("作者名字", userNameEditingController),
            inputBox("作者简介", userDetailEditingController),
            uploadBox(
                "上传头像 (png/jpg)", onUploadUserAvatarLogo, userAvatarWidget),
            saveButton(save),
          ],
        ),
      ],
    );
  }

  getAndDisplayUserAvatarItem(
    String key,
    Map<String, dynamic> items,
  ) {
    if (!items.containsKey(key)) {
      return;
    }
    var item = items[key];
    var path = item["value"] as String;
    widget.platformClient
        .getObject<String>(
      path,
      contentType: ContentTypeConfig.ico,
    )
        .then((value) {
      if (value.isSuccess) {
        userAvatarFileBytes = string2Uint8list(value.message!);
        userAvatarWidget = Image.memory(
          userAvatarFileBytes!,
          width: 60,
          height: 60,
        );
        setState(() {});
      } else {
        print(value.errorMessage);
      }
    });
  }
}
