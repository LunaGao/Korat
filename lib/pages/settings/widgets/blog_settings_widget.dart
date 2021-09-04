import 'package:flutter/material.dart';
import 'package:korat/pages/settings/widgets/common/common_settings.dart';

class BlogSettingsWidget extends StatefulWidget {
  const BlogSettingsWidget({Key? key}) : super(key: key);

  @override
  _BlogSettingsWidgetState createState() => _BlogSettingsWidgetState();
}

class _BlogSettingsWidgetState extends State<BlogSettingsWidget> {
  var blogTitleEditingController = TextEditingController();

  save() {
    print("save1");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...group(
          "博客基础设置",
          baseSettingsWidgets(),
        ),
      ],
    );
  }

  List<Widget> baseSettingsWidgets() {
    return [
      inputBox("博客名字", blogTitleEditingController),
      inputBox("域名", blogTitleEditingController),
      inputBox("博客简介", blogTitleEditingController),
      inputBox("博客Icon", blogTitleEditingController),
      inputBox("备案号", blogTitleEditingController),
      inputBox("Copyright", blogTitleEditingController),
      saveButton(save),
    ];
  }
}
