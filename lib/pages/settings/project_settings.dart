import 'package:flutter/material.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/project.dart';
import 'package:korat/pages/dashboard/widgets/utils_widget.dart';
import 'package:korat/pages/settings/widgets/blog_settings_widget.dart';
import 'package:korat/pages/settings/widgets/style_settings_widget.dart';
import 'package:korat/pages/settings/widgets/user_settings_widget.dart';

class ProjectSettingsPage extends StatefulWidget {
  const ProjectSettingsPage({Key? key}) : super(key: key);

  @override
  _ProjectSettingsPageState createState() => _ProjectSettingsPageState();
}

class _ProjectSettingsPageState extends State<ProjectSettingsPage> {
  ProjectSettingsPageArguments? _arg;
  ProjectModel? project;
  List<String> settingsItems = [
    "博客设置",
    "作者设置",
    "样式设置",
    "首页模板",
    "帖子模板",
  ];
  int selectedSettingItemsIndex = 0;

  onClickSettingItem(int index) {
    selectedSettingItemsIndex = index;
    setState(() {});
  }

  Widget settingsContentWidget(int index) {
    switch (index) {
      case 0:
        return BlogSettingsWidget(getPlatformClient(project!));
      case 1:
        return UserSettingsWidget(getPlatformClient(project!));
      case 2:
        return StyleSettingsWidget();
    }
    return Text("未找到对应的设置内容。");
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg = ModalRoute.of(context)!.settings.arguments
          as ProjectSettingsPageArguments;
      project = _arg!.projectModel;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(project!.name + " 设置"),
          ],
        ),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          settingsItemsWidget(),
          DashboardDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: settingsContentWidget(selectedSettingItemsIndex),
          ),
        ],
      ),
    );
  }

  Widget settingsItemsWidget() {
    return Container(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: ListView.builder(
          itemCount: settingsItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              selected: selectedSettingItemsIndex == index,
              title: Text(
                settingsItems[index],
                style: TextStyle(),
              ),
              onTap: () => onClickSettingItem(index),
            );
          },
        ),
      ),
    );
  }
}

class ProjectSettingsPageArguments {
  final ProjectModel projectModel;

  ProjectSettingsPageArguments(
    this.projectModel,
  );
}
