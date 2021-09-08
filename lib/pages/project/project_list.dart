import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/project_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/project.dart';
import 'package:korat/pages/project/project_editor.dart';
import 'package:korat/routes/app_routes.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  bool _isLoading = true;
  List<ProjectModel> projects = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var projectResponse =
        await ProjectApi().getMyProjects(Global.user!.objectId);
    if (projectResponse.isSuccess) {
      projects = projectResponse.message!;
    } else {
      EasyLoading.showError(projectResponse.errorMessage);
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "项目管理",
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                  AppRoute.project_editor,
                  arguments: ProjectEditorPageArguments(
                    ProjectType.create,
                  ),
                )
                    .then<bool?>((value) {
                  if (value != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    getData();
                  }
                });
              },
              child: Text(
                "添加项目",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: mainBody(),
    );
  }

  void removeProject(int index) {
    showOkCancelAlertDialog(
      title: "是否删除此项目？删除后无法找回",
      context: context,
    ).then((value) async {
      if (value == OkCancelResult.ok) {
        var result = await ProjectApi().deleteProject(projects[index].objectId);
        if (result.isSuccess) {
          getData();
          EasyLoading.showSuccess("删除成功");
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  Widget mainBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (buildContext, index) {
                return _projectItem(
                  index,
                );
              },
            ),
    );
  }

  Widget _projectItem(int index) {
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => removeProject(index),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(
          AppRoute.project_editor,
          arguments: ProjectEditorPageArguments(
            ProjectType.modify,
            projectModel: projects[index],
          ),
        )
            .then<bool?>((value) {
          if (value != null) {
            setState(() {
              _isLoading = true;
            });
            getData();
          }
        });
      },
      title: Text(
        projects[index].name,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: new Border.all(width: 1, color: Colors.green),
            ),
            child: Text(
              "平台：" + getDisplayProjectNameFromString(projects[index].platform),
            ),
          ),
        ],
      ),
    );
  }
}
