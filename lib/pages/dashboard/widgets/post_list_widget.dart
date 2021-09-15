import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/logic/publish/publish_client.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/post_item.dart';
import 'package:korat/models/project.dart';
import 'package:korat/pages/settings/project_settings.dart';
import 'package:korat/routes/app_routes.dart';

class PostListWidget extends StatefulWidget {
  final PostListController postListController;
  const PostListWidget({
    required this.postListController,
    Key? key,
  }) : super(key: key);

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  bool loading = true;
  bool success = true;
  PostConfig postsConfig = PostConfig([]);
  int selectedPostIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.postListController.addPostListListener(() {
      getData();
    });
  }

  void getData() async {
    loading = true;
    setState(() {});
    var result = await widget.postListController
        .getPlatform()
        .getObject<String>(ObjModel(
          ConfigFilePath.postsConfigPath,
          null,
          ContentTypeConfig.json,
        ));
    if (result.isSuccess) {
      postsConfig = PostConfig.fromJson(jsonDecode(result.message!));
    } else {
      print("error: " + result.errorMessage);
    }
    loading = false;
    setState(() {});
  }

  onCreatePost() {
    showTextInputDialog(
      title: "请输入标题",
      context: context,
      textFields: [
        DialogTextField(),
      ],
    ).then((value) async {
      if (value != null && value.length != 0) {
        String displayName = value[0];
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String fileFullNamePath = 'korat/post/data/$fileName.md';
        var result = await widget.postListController.getPlatform().putObject(
              ObjModel(
                fileFullNamePath,
                ' ',
                ContentTypeConfig.text,
              ),
            );
        if (result.isSuccess) {
          var post = Post(
            fileName,
            fileFullNamePath,
            displayName,
            DateTime.now().toString(),
            [],
            "",
          );
          postsConfig.posts.add(post);
          await widget.postListController.getPlatform().putObject(
                ObjModel(
                  ConfigFilePath.postsConfigPath,
                  json.encode(postsConfig),
                  ContentTypeConfig.json,
                ),
              );
          getData();
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  onClickSettingsButton() {
    Navigator.of(context).pushNamed(
      AppRoute.project_settings,
      arguments: ProjectSettingsPageArguments(
        widget.postListController.getCurrentProject(),
      ),
    );
  }

  onPublishPost() {
    showOkCancelAlertDialog(
      title: "是否发布内容到发布平台？",
      context: context,
    ).then((value) async {
      if (value == OkCancelResult.ok) {
        EasyLoading.showProgress(
          0.4,
          status: "生成中，请勿关闭网页。",
          maskType: EasyLoadingMaskType.black,
        );
        await PublishClient()
            .publish(widget.postListController.getCurrentProject());
        await EasyLoading.dismiss();
        EasyLoading.showSuccess("发布成功");
      }
    });
  }

  onDeletePost(Post post) {
    showOkCancelAlertDialog(
      title: "是否删除？",
      context: context,
    ).then((value) async {
      if (value == OkCancelResult.ok) {
        postsConfig.posts.remove(post);
        await widget.postListController.getPlatform().putObject(
              ObjModel(
                ConfigFilePath.postsConfigPath,
                json.encode(postsConfig),
                ContentTypeConfig.json,
              ),
            );
        var result = await widget.postListController.getPlatform().deleteObject(
              ObjModel(
                post.fileFullNamePath,
                ' ',
                ' ',
              ),
            );
        if (result.isSuccess) {
          selectedPostIndex = -1;
          getData();
          widget.postListController.onClickPostTitle(null);
          EasyLoading.showSuccess("删除成功");
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  onClickPostItem(int index) async {
    ResponseModel<String> responseModel =
        await widget.postListController.getPlatform().getObject<String>(
              ObjModel(
                postsConfig.posts[index].fileFullNamePath,
                '',
                ContentTypeConfig.text,
              ),
            );
    if (responseModel.isSuccess) {
      PostItem postItem = PostItem(
        postsConfig.posts[index].fileFullNamePath,
        value: (responseModel.message as String).trimRight(),
      );
      selectedPostIndex = index;
      widget.postListController.onClickPostTitle(postItem);
    } else {
      selectedPostIndex = -1;
      widget.postListController.onClickPostTitle(null);
      EasyLoading.showError("载入错误");
      getData();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: "创建帖子",
                        onPressed: () {
                          onCreatePost();
                        },
                        icon: Icon(
                          Icons.create_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(
                        tooltip: "设置",
                        onPressed: () {
                          onClickSettingsButton();
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                        ),
                      ),
                      IconButton(
                        tooltip: "发布",
                        onPressed: () {
                          onPublishPost();
                        },
                        icon: Icon(
                          Icons.publish_outlined,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: postsConfig.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return postItemWidget(index);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget postItemWidget(int index) {
    return ListTile(
      selected: selectedPostIndex == index,
      onTap: () => onClickPostItem(index),
      title: Text(
        postsConfig.posts[index].displayFileName,
        style: TextStyle(
          fontWeight:
              selectedPostIndex == index ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      trailing: PopupMenuButton<String>(
        child: Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == 'delete') {
            onDeletePost(postsConfig.posts[index]);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ),
                Text('删除'),
              ],
            ),
            value: 'delete',
          ),
        ],
      ),
    );
  }
}

class PostListController {
  ProjectModel? _project;
  PlatformClient? _platform;
  PostCallback? _postCallback;
  VoidCallback? _postListListener;

  void setCurrentProject(ProjectModel projectModel) {
    this._project = projectModel;
    this._platform = getPlatformClient(projectModel);
  }

  ProjectModel getCurrentProject() {
    return this._project!;
  }

  PlatformClient getPlatform() {
    return this._platform!;
  }

  void onClickPostTitle(PostItem? postItem) {
    if (this._postCallback != null) {
      this._postCallback!(postItem);
    }
  }

  void addListener(PostCallback callback) {
    this._postCallback = callback;
  }

  void addPostListListener(VoidCallback callback) {
    this._postListListener = callback;
    if (this._postListListener != null && this._platform != null) {
      this._postListListener!();
    }
  }
}

typedef PostCallback = void Function(PostItem? post);
