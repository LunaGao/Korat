import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/post.dart';

class EditorWidget extends StatefulWidget {
  final EditorController editorController;
  const EditorWidget({
    required this.editorController,
    Key? key,
  }) : super(key: key);

  @override
  _EditorWidgetState createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  TextEditingController textEditingController = TextEditingController();
  bool showWelcomePage = true;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      widget.editorController.sendTextToListener(textEditingController.text);
    });
    widget.editorController.addVoidListner(() {
      textEditingController.text = widget.editorController.getPost().value;
      setState(() {
        showWelcomePage = widget.editorController.getShowWelcomePage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: showWelcomePage
            ? Center(
                child: Text(
                  "开始记录的奇妙之旅吧",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 40,
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      getTopControllerButtons(),
                      TextButton(
                        onPressed: () async {
                          var result = await widget.editorController
                              .getPlatform()
                              .putObject(
                                  widget.editorController.getPost().fileName,
                                  textEditingController.text);
                          if (result.isSuccess) {
                            print(result.message);
                            EasyLoading.showSuccess("保存成功！");
                          } else {
                            print(result.errorMessage);
                            EasyLoading.showError(result.errorMessage);
                          }
                        },
                        child: Text("保存"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: "开始记录的奇妙之旅吧",
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget getTopControllerButtons() {
    return Expanded(
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: WrapAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            tooltip: "加粗",
            icon: Icon(
              Icons.format_bold_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_italic_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_clear_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_quote_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_list_bulleted_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_list_numbered_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.checklist_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.insert_link_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.insert_photo_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.table_chart_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class EditorController {
  StringCallback? _stringCallback;
  VoidCallback? _voidCallback;
  Post? _post;
  bool _showWelcomePage = true;
  AliyunOSSClient? _platform;

  void setStorePlatform(AliyunOSSClient oss) {
    this._platform = oss;
  }

  AliyunOSSClient getPlatform() {
    return this._platform!;
  }

  void addListener(StringCallback callback) {
    _stringCallback = callback;
  }

  void addVoidListner(VoidCallback callback) {
    _voidCallback = callback;
  }

  void reset() {}

  void setPost(Post? post) {
    this._post = post;
    if (post == null) {
      this._showWelcomePage = true;
    } else {
      this._showWelcomePage = false;
    }
    if (this._voidCallback != null) {
      this._voidCallback!();
    }
  }

  Post getPost() {
    if (_post == null) {
      return Post('', '', '');
    }
    return this._post!;
  }

  bool getShowWelcomePage() {
    return this._showWelcomePage;
  }

  void sendTextToListener(String text) {
    if (this._stringCallback != null) {
      this._stringCallback!(text);
    }
  }
}

typedef StringCallback = void Function(String text);
