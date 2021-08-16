import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PreviewWidget extends StatefulWidget {
  final PreviewController previewController;
  const PreviewWidget({
    required this.previewController,
    Key? key,
  }) : super(key: key);

  @override
  _PreviewWidgetState createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  String markdownString = '';
  bool showWelcome = true;

  @override
  void initState() {
    super.initState();
    widget.previewController.addDisplayListener(() {
      setState(() {
        showWelcome = widget.previewController.getIsShowWelcomePage();
        markdownString = widget.previewController.getDisplayValue();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: showWelcome
            ? Center(
                child: Text(
                  "这里是预览",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 40,
                  ),
                ),
              )
            : Markdown(
                shrinkWrap: true,
                data: markdownString,
              ),
      ),
    );
  }
}

class PreviewController {
  String _displayValue = '';
  bool _showWelcomePage = true;
  VoidCallback? _displayListener;

  PreviewController();

  void setDisplayValue(
    String displayValue, {
    bool showWelcomePage = false,
  }) {
    this._displayValue = displayValue;
    this._showWelcomePage = showWelcomePage;
    if (_displayListener != null) {
      _displayListener!();
    }
  }

  String getDisplayValue() {
    return this._displayValue;
  }

  bool getIsShowWelcomePage() {
    return this._showWelcomePage;
  }

  void addDisplayListener(VoidCallback callback) {
    _displayListener = callback;
  }
}
