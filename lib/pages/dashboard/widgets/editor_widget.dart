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

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      widget.editorController.sendTextToListener(textEditingController.text);
    });
    widget.editorController.addVoidListner(() {
      textEditingController.text = widget.editorController.getText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: textEditingController,
            )
          ],
        ),
      ),
    );
  }
}

class EditorController {
  StringCallback? _stringCallback;
  VoidCallback? _voidCallback;
  String _text = '';

  void addListener(StringCallback callback) {
    _stringCallback = callback;
  }

  void addVoidListner(VoidCallback callback) {
    _voidCallback = callback;
  }

  void reset() {}

  void setText(String text) {
    _text = text;
    if (_voidCallback != null) {
      _voidCallback!();
    }
  }

  String getText() {
    return _text;
  }

  void sendTextToListener(String text) {
    if (_stringCallback != null) {
      _stringCallback!(text);
    }
  }
}

typedef StringCallback = void Function(String text);
