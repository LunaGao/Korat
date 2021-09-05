import 'package:flutter/material.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/pages/dashboard/widgets/utils_widget.dart';
import 'package:korat/pages/settings/widgets/blog_settings_widget.dart';
import 'package:korat/pages/settings/widgets/style_settings_widget.dart';
import 'package:korat/pages/settings/widgets/user_settings_widget.dart';

class PlatformGroupSettingsPage extends StatefulWidget {
  const PlatformGroupSettingsPage({Key? key}) : super(key: key);

  @override
  _PlatformGroupSettingsPageState createState() =>
      _PlatformGroupSettingsPageState();
}

class _PlatformGroupSettingsPageState extends State<PlatformGroupSettingsPage> {
  PlatformGroupSettingsPageArguments? _arg;
  PlatformGroup? platformGroup;
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
        return BlogSettingsWidget(
            getPlatformClient(platformGroup!.dataPlatform!));
      case 1:
        return UserSettingsWidget();
      case 2:
        return StyleSettingsWidget();
    }
    return Text("未找到对应的设置内容。");
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg = ModalRoute.of(context)!.settings.arguments
          as PlatformGroupSettingsPageArguments;
      platformGroup = _arg!.platformGroup;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(platformGroup!.name + " 设置"),
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

class PlatformGroupSettingsPageArguments {
  final PlatformGroup platformGroup;

  PlatformGroupSettingsPageArguments(
    this.platformGroup,
  );
}
