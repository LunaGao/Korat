import 'package:flutter/material.dart';

class BoldLogic {
  String bold(
    TextEditingController textEditingController,
    TextSelection? textSelection,
  ) {
    if (textSelection == null ||
        (textSelection.start == -1 && textSelection.end == -1)) {
      print("empty");
      return textEditingController.text + '****';
    }
    var text = '**' +
        textSelection.textInside(
          textEditingController.text,
        ) +
        '**';
    text = textEditingController.text.replaceRange(
      textSelection.start,
      textSelection.end,
      text,
    );
    print(text);
    textEditingController.text = text;
    return textEditingController.text;
  }
}
