import 'package:flutter/material.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppbarController appbarController;
  const DashboardAppBar({
    Key? key,
    required this.appbarController,
  }) : super(key: key);

  @override
  _DashboardAppBarState createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  List<PopupMenuEntry<String>> popupMenuItems = [];
  String selectedPopupMenuItemTitle = "";
  List<PlatformGroup>? platformGroups;

  @override
  initState() {
    super.initState();
    widget.appbarController.addPlatformGroupsListener(
      (platformGroups) => setPlatformGroups(platformGroups),
    );
    getUserData();
  }

  void setPlatformGroups(List<PlatformGroup> platformGroups) {
    popupMenuItems.clear();
    this.platformGroups = platformGroups;
    for (PlatformGroup item in platformGroups) {
      var value = PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(item.name),
          ],
        ),
        value: item.name,
      );
      popupMenuItems.add(value);
    }
    selectedPopupMenuItemTitle = platformGroups[0].name;
    onSelectedPlatformGroup(selectedPopupMenuItemTitle);
    setState(() {});
  }

  void onSelectedPlatformGroup(String platformName) {
    for (var item in this.platformGroups!) {
      widget.appbarController.sendChangePlatformGroupCallback(item);
    }
  }

  void getUserData() async {
    var meResponse = await UserApi().me();
    if (!meResponse.isSuccess) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('sessionToken');
      Navigator.of(context).pushReplacementNamed(AppRoute.home);
    }
    var user = meResponse.message!;
    widget.appbarController.getUserListener(user);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("操作台"),
          ),
          popupMenuItems.isEmpty
              ? Container()
              : PopupMenuButton<String>(
                  tooltip: "选择平台组",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          this.selectedPopupMenuItemTitle,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_drop_down),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    onSelectedPlatformGroup(value);
                  },
                  itemBuilder: (BuildContext context) => popupMenuItems,
                ),
          TextButton(
            onPressed: () {},
            child: Text(
              "平台组管理",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backwardsCompatibility: false,
      actions: [
        TextButton(
          onPressed: () {
            SharedPreferences.getInstance().then((prefs) {
              prefs.remove('sessionToken');
              prefs.remove('currentUserId');
              Navigator.of(context).pushReplacementNamed(AppRoute.home);
            });
          },
          child: Text(
            "退出",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class AppbarController {
  UserCallback? _userCallback;
  PlatformGroupsCallback? _platformGroupsCallback;
  ChangePlatformGroupCallback? _changePlatformGroupCallback;

  addUserListener(UserCallback callback) {
    this._userCallback = callback;
  }

  getUserListener(User user) {
    this._userCallback!(user);
  }

  addChangePlatformGroupCallback(ChangePlatformGroupCallback callback) {
    this._changePlatformGroupCallback = callback;
  }

  sendChangePlatformGroupCallback(PlatformGroup platformGroup) {
    this._changePlatformGroupCallback!(platformGroup);
  }

  addPlatformGroupsListener(PlatformGroupsCallback callback) {
    this._platformGroupsCallback = callback;
  }

  setPlatformGroups(List<PlatformGroup> platformGroups) {
    this._platformGroupsCallback!(platformGroups);
  }
}

typedef UserCallback = void Function(User user);
typedef PlatformGroupsCallback = void Function(
    List<PlatformGroup> platformGroups);
typedef ChangePlatformGroupCallback = void Function(
    PlatformGroup platformGroup);
