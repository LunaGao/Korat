import 'package:flutter/material.dart';
import 'package:korat/pages/settings/widgets/common/common_settings.dart';

class StyleSettingsWidget extends StatefulWidget {
  const StyleSettingsWidget({Key? key}) : super(key: key);

  @override
  _StyleSettingsWidgetState createState() => _StyleSettingsWidgetState();
}

class _StyleSettingsWidgetState extends State<StyleSettingsWidget> {
  var cssEditingController = TextEditingController();
  var jsEditingController = TextEditingController();

  save() {
    print("save3");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...group("CSS / JS 设置", cssAndJsSettingsWidgets()),
      ],
    );
  }

  List<Widget> cssAndJsSettingsWidgets() {
    return [
      inputBox("CSS 设置", cssEditingController),
      inputBox("JS 设置", jsEditingController),
      saveButton(save),
    ];
  }
}
