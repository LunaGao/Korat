import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/post.dart';
import 'package:korat/api/base_model/response_model.dart';

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
  List<Post> posts = [];
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
    var result = await widget.postListController.getPlatform().listObjects();
    if (result.isSuccess) {
      posts = result.message!;
      success = true;
    } else {
      success = false;
      print(result.errorMessage);
      EasyLoading.showError(result.errorMessage);
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
      print(value);
      if (value != null && value.length != 0) {
        var result = await widget.postListController
            .getPlatform()
            .putObject('korat/' + value[0] + '.md', ' ');
        if (result.isSuccess) {
          print(result.message);
          getData();
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  onDeletePost(Post post) {
    showOkCancelAlertDialog(
      title: "是否删除？",
      context: context,
    ).then((value) async {
      print(value);
      if (value == OkCancelResult.ok) {
        var result =
            await widget.postListController.getPlatform().deleteObject(post);
        if (result.isSuccess) {
          selectedPostIndex = -1;
          getData();
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
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
                  TextButton(
                    onPressed: () {
                      onCreatePost();
                    },
                    child: Text("创建帖子"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
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
      onTap: () async {
        ResponseModel<Post> responseModel = await widget.postListController
            .getPlatform()
            .getObject(posts[index]);
        if (responseModel.isSuccess) {
          selectedPostIndex = index;
          widget.postListController.onClickPostTitle(responseModel.message);
        } else {
          selectedPostIndex = -1;
          widget.postListController.onClickPostTitle(null);
          EasyLoading.showError("载入错误");
          getData();
        }
        setState(() {});
      },
      title: Text(posts[index].displayFileName),
      trailing: PopupMenuButton<String>(
        child: Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == 'delete') {
            onDeletePost(posts[index]);
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
  AliyunOSSClient? _platform;
  PostCallback? _postCallback;
  VoidCallback? _postListListener;

  void setStorePlatform(AliyunOSSClient oss) {
    this._platform = oss;
    if (this._postListListener != null) {
      this._postListListener!();
    }
  }

  AliyunOSSClient getPlatform() {
    return this._platform!;
  }

  void onClickPostTitle(Post? post) {
    if (this._postCallback != null) {
      this._postCallback!(post);
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

typedef PostCallback = void Function(Post? post);
