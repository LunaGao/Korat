import 'package:flutter/material.dart';

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
      textEditingController.text = widget.editorController.getText();
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
                        onPressed: () {},
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
  String _text = '';
  bool _showWelcomePage = true;

  void addListener(StringCallback callback) {
    _stringCallback = callback;
  }

  void addVoidListner(VoidCallback callback) {
    _voidCallback = callback;
  }

  void reset() {}

  void setText(String text) {
    _text = text;
    _showWelcomePage = false;
    if (_voidCallback != null) {
      _voidCallback!();
    }
  }

  String getText() {
    return _text;
  }

  bool getShowWelcomePage() {
    return this._showWelcomePage;
  }

  void sendTextToListener(String text) {
    if (_stringCallback != null) {
      _stringCallback!(text);
    }
  }
}

typedef StringCallback = void Function(String text);
