import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/pages/settings/widgets/common/common_settings.dart';

class BlogSettingsWidget extends StatefulWidget {
  final PlatformClient platformClient;
  const BlogSettingsWidget(
    this.platformClient, {
    Key? key,
  }) : super(key: key);

  @override
  _BlogSettingsWidgetState createState() => _BlogSettingsWidgetState();
}

class _BlogSettingsWidgetState extends State<BlogSettingsWidget> {
  var blogTitleEditingController = TextEditingController();
  var domainEditingController = TextEditingController();
  var blogDetailEditingController = TextEditingController();
  var recordEditingController = TextEditingController();
  var copyrightEditingController = TextEditingController();
  var data = Map<String, dynamic>();
  bool isChangedLogo = false;
  Uint8List? blogIconFileBytes;
  Widget? blogLogoWidget;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var response = await widget.platformClient.getObject<String>(
      ObjModel(
        ConfigFilePath.blogSettingPath,
        null,
        ContentTypeConfig.json,
      ),
    );
    if (response.isSuccess) {
      data = jsonDecode(response.message!);
      getAndDisplayInputItem(
          SettingsConfig.blogTitleKey, blogTitleEditingController, data);
      getAndDisplayInputItem(
          SettingsConfig.blogDomainKey, domainEditingController, data);
      getAndDisplayInputItem(
          SettingsConfig.blogDetailKey, blogDetailEditingController, data);
      getAndDisplayInputItem(
          SettingsConfig.blogRecordKey, recordEditingController, data);
      getAndDisplayInputItem(
          SettingsConfig.blogCopyrightKey, copyrightEditingController, data);
      getAndDisplayBlogIconItem(SettingsConfig.blogLogoKey, data);
      setState(() {});
    } else {
      print(response.errorMessage);
      EasyLoading.showError(response.errorMessage);
    }
  }

  save() async {
    var items = Map<String, dynamic>();
    var blogIconPath = '';
    if (isChangedLogo) {
      if (blogIconFileBytes != null) {
        blogIconPath = ConfigFilePath.imagePathPrefix +
            DateTime.now().millisecondsSinceEpoch.toString() +
            ".ico";
        await widget.platformClient.putObject(
          ObjModel(
            blogIconPath,
            blogIconFileBytes!,
            ContentTypeConfig.ico,
            isPublic: true,
          ),
        );
      }
      isChangedLogo = false;
    } else {
      if (data.containsKey(SettingsConfig.blogLogoKey)) {
        var item = data[SettingsConfig.blogLogoKey];
        blogIconPath = item["value"];
      }
    }
    setItem(SettingsConfig.blogTitleKey, blogTitleEditingController, items);
    setItem(SettingsConfig.blogDomainKey, domainEditingController, items);
    setItem(SettingsConfig.blogDetailKey, blogDetailEditingController, items);
    setItem(SettingsConfig.blogRecordKey, recordEditingController, items);
    setItem(SettingsConfig.blogCopyrightKey, copyrightEditingController, items);
    setItem(SettingsConfig.blogLogoKey, null, items, value: blogIconPath);
    widget.platformClient
        .putObject(
      ObjModel(
        ConfigFilePath.blogSettingPath,
        jsonEncode(items),
        ContentTypeConfig.json,
      ),
    )
        .then((value) {
      EasyLoading.showSuccess("保存成功");
    });
  }

  getAndDisplayBlogIconItem(
    String key,
    Map<String, dynamic> items,
  ) {
    var item = items[key];
    var path = item["value"] as String;
    widget.platformClient
        .getObject<Uint8List>(
      ObjModel(
        path,
        null,
        ContentTypeConfig.ico,
      ),
    )
        .then((value) {
      if (value.isSuccess) {
        blogLogoWidget = Image.memory(
          value.message!,
          width: 20,
          height: 20,
        );
        setState(() {});
      } else {
        print(value.errorMessage);
      }
    });
  }

  onUploadBlogLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ico'],
    );

    if (result != null) {
      blogIconFileBytes = result.files.first.bytes;
      blogLogoWidget = Image.memory(
        blogIconFileBytes!,
        width: 20,
        height: 20,
      );
      isChangedLogo = true;
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
          "博客基础设置",
          [
            inputBox("博客名字", blogTitleEditingController),
            inputBox("域名", domainEditingController),
            inputBox("博客简介", blogDetailEditingController),
            uploadBox("上传博客Icon (.ico)", onUploadBlogLogo, blogLogoWidget),
            inputBox("备案号", recordEditingController),
            inputBox("Copyright", copyrightEditingController),
            saveButton(save),
          ],
        ),
      ],
    );
  }
}
