import 'package:flutter/material.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/common/global.dart';
import 'package:korat/models/project.dart';
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
  List<ProjectModel>? projects;

  @override
  initState() {
    super.initState();
    widget.appbarController.addProjectsListener(
      (_projects) => setProject(_projects),
    );
    getUserData();
  }

  void setProject(List<ProjectModel> projectList) {
    popupMenuItems.clear();
    this.projects = projectList;
    for (ProjectModel item in projectList) {
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
    selectedPopupMenuItemTitle = projectList[0].name;
    onSelectedProject(selectedPopupMenuItemTitle);
    setState(() {});
  }

  void onSelectedProject(String projectName) {
    for (var item in this.projects!) {
      if (item.name == projectName) {
        widget.appbarController.sendChangeProjectCallback(item);
      }
    }
  }

  void getUserData() async {
    if (Global.user != null) {
      widget.appbarController.getUserListener(Global.user!);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          popupMenuItems.isEmpty
              ? Container()
              : PopupMenuButton<String>(
                  tooltip: "选择项目",
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
                    onSelectedProject(value);
                  },
                  itemBuilder: (BuildContext context) => popupMenuItems,
                ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.project_list);
            },
            child: Text(
              "项目管理",
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
            SharedPreferences.getInstance().then((prefs) async {
              await Global.logout();
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
  ProjectsCallback? _projectsCallback;
  ChangeProjectCallback? _changeProjectCallback;

  addUserListener(UserCallback callback) {
    this._userCallback = callback;
  }

  getUserListener(User user) {
    this._userCallback!(user);
  }

  addChangeProjectCallback(ChangeProjectCallback callback) {
    this._changeProjectCallback = callback;
  }

  sendChangeProjectCallback(ProjectModel project) {
    this._changeProjectCallback!(project);
  }

  addProjectsListener(ProjectsCallback callback) {
    this._projectsCallback = callback;
  }

  setProjectModels(List<ProjectModel> projects) {
    this._projectsCallback!(projects);
  }
}

typedef UserCallback = void Function(User user);
typedef ProjectsCallback = void Function(List<ProjectModel> projects);
typedef ChangeProjectCallback = void Function(ProjectModel project);
