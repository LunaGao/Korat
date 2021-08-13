import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PreviewWidget extends StatefulWidget {
  final String displayValue;
  const PreviewWidget(this.displayValue, {Key? key}) : super(key: key);

  @override
  _PreviewWidgetState createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Markdown(
          shrinkWrap: true,
          data: widget.displayValue,
        ),
      ),
    );
  }
}
