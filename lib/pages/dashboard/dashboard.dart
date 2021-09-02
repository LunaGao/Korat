import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/platform_group_api.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/pages/dashboard/widgets/dashboard_appbar.dart';
import 'package:korat/pages/platform/platform_group/platform_group_editor.dart';
import 'package:korat/pages/dashboard/widgets/editor_widget.dart';
import 'package:korat/pages/dashboard/widgets/post_list_widget.dart';
import 'package:korat/pages/dashboard/widgets/preview_widget.dart';
import 'package:korat/pages/dashboard/widgets/utils_widget.dart';
import 'package:korat/routes/app_routes.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  bool loading = true;
  User user = User();
  bool emptyPlatform = false;
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
    appbarController.addChangePlatformGroupCallback((platformGroup) {
      if (platformGroup.dataPlatform == null) {
        Navigator.of(context).popAndPushNamed(
          AppRoute.platform_group_editor,
          arguments: PlatformGroupPageArguments(
            PlatformGroupType.modify,
            platformGroup: platformGroup,
          ),
        );
      }
    });
  }

  void getData() async {
    var platformGroupsResponse =
        await PlatformGroupApi().getMyPlatformGroups(user.objectId);
    if (platformGroupsResponse.isSuccess) {
      if (platformGroupsResponse.message!.length == 0) {
        Navigator.of(context).popAndPushNamed(
          AppRoute.platform_group_editor,
          arguments: PlatformGroupPageArguments(
            PlatformGroupType.first,
          ),
        );
        return;
      } else {
        appbarController.setPlatformGroups(platformGroupsResponse.message!);
        postListController
            .setCurrentPlatformGroup(platformGroupsResponse.message![0]);
        var dataPlatform = platformGroupsResponse.message![0].dataPlatform!;
        platformClient = getPlatformClient(dataPlatform);
        postListController.setStorePlatform(platformClient!);
        editorController.setStorePlatform(platformClient!);
      }
    } else {
      EasyLoading.showError(platformGroupsResponse.errorMessage);
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
          child: platformWidget(),
        ),
      ],
    );
  }

  Widget platformWidget() {
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
