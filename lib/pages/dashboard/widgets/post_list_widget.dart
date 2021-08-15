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
            .putObject(value[0], ' ');
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
          print(result.message);
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
            : ListView(
                children: [
                  ...postListWidget(),
                  TextButton(
                    onPressed: () {
                      onCreatePost();
                    },
                    child: Text("创建帖子"),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> postListWidget() {
    List<Widget> returnValue = [];
    for (var post in posts) {
      var postItem = ListTile(
        onTap: () async {
          ResponseModel<Post> responseModel =
              await widget.postListController.getPlatform().getObject(post);
          String displayValue;
          if (responseModel.isSuccess) {
            displayValue = responseModel.message!.value;
          } else {
            displayValue = responseModel.errorMessage;
          }
          widget.postListController.onClickPostTitle(displayValue);
          setState(() {});
        },
        title: Text(post.displayFileName),
        trailing: PopupMenuButton<String>(
          child: Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'delete') {
              onDeletePost(post);
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
      returnValue.add(postItem);
    }
    return returnValue;
  }
}

class PostListController {
  AliyunOSSClient? _platform;
  StringCallback? _stringCallback;
  VoidCallback? _postListListener;

  void setStorePlatform(AliyunOSSClient oss) {
    _platform = oss;
    if (_postListListener != null) {
      _postListListener!();
    }
  }

  AliyunOSSClient getPlatform() {
    return _platform!;
  }

  void onClickPostTitle(String value) {
    if (_stringCallback != null) {
      _stringCallback!(value);
    }
  }

  void addListener(StringCallback callback) {
    _stringCallback = callback;
  }

  void addPostListListener(VoidCallback callback) {
    _postListListener = callback;
    if (_postListListener != null && _platform != null) {
      _postListListener!();
    }
  }
}

typedef StringCallback = void Function(String text);
