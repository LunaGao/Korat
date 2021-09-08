import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/project_api.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/pages/dashboard/widgets/dashboard_appbar.dart';
import 'package:korat/pages/dashboard/widgets/editor_widget.dart';
import 'package:korat/pages/dashboard/widgets/post_list_widget.dart';
import 'package:korat/pages/dashboard/widgets/preview_widget.dart';
import 'package:korat/pages/dashboard/widgets/utils_widget.dart';
import 'package:korat/pages/project/project_editor.dart';
import 'package:korat/routes/app_routes.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  bool loading = true;
  User user = User();
  PlatformClient? platformClient;
  AppbarController appbarController = AppbarController();
  EditorController editorController = EditorController();
  PostListController postListController = PostListController();
  PreviewController previewController = PreviewController();

  @override
  void initState() {
    super.initState();
    editorController.addListener((text) {
      previewController.setDisplayValue(text);
    });
    postListController.addListener((postItem) {
      editorController.reset();
      editorController.setPostItem(postItem);
      previewController.setDisplayValue(
        postItem == null ? '' : postItem.value,
        showWelcomePage: postItem == null,
      );
    });
    appbarController.addUserListener((user) {
      this.user = user;
      getData();
    });
    appbarController.addChangeProjectCallback((project) {
      if (project.name == '') {
        Navigator.of(context).popAndPushNamed(
          AppRoute.project_editor,
          arguments: ProjectEditorPageArguments(
            ProjectType.modify,
            projectModel: project,
          ),
        );
      }
    });
  }

  void getData() async {
    var projectResponse = await ProjectApi().getMyProjects(user.objectId);
    if (projectResponse.isSuccess) {
      if (projectResponse.message!.length == 0) {
        Navigator.of(context).popAndPushNamed(
          AppRoute.project_editor,
          arguments: ProjectEditorPageArguments(
            ProjectType.first,
          ),
        );
        return;
      } else {
        appbarController.setProjectModels(projectResponse.message!);
        postListController.setCurrentProject(projectResponse.message![0]);
        editorController.setCurrentProject(projectResponse.message![0]);
      }
    } else {
      EasyLoading.showError(projectResponse.errorMessage);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        appbarController: appbarController,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mainBody(),
    );
  }

  Widget mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        EmailNotVerifiedWidget(
          user,
        ),
        Expanded(
          child: projectWidget(),
        ),
      ],
    );
  }

  Widget projectWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostListWidget(
          postListController: postListController,
        ),
        DashboardDivider(),
        EditorWidget(
          editorController: editorController,
        ),
        DashboardDivider(),
        PreviewWidget(
          previewController: previewController,
        ),
      ],
    );
  }
}
