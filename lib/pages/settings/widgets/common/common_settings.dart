import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

List<Widget> group(
  String title,
  List<Widget> content,
) {
  return [
    SizedBox(
      height: 10,
    ),
    Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    ...content,
    SizedBox(
      height: 20,
    ),
  ];
}

Widget inputBox(
  String title,
  TextEditingController textEditingController,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 500.0,
      child: TextField(
        controller: textEditingController,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: title,
        ),
      ),
    ),
  );
}

Widget saveButton(VoidCallback callback) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      child: Text("保存"),
      onPressed: () {
        callback();
      },
    ),
  );
}

Widget uploadBox(
  String title,
  VoidCallback callback,
  Widget? displayWidget,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => callback(),
          child: Text(title),
        ),
        SizedBox(
          width: 10,
        ),
        displayWidget == null ? Text("未设置") : displayWidget,
      ],
    ),
  );
}

Uint8List string2Uint8list(String s) {
  var encodedString = utf8.encode(s);
  var encodedLength = encodedString.length;
  var data = ByteData(encodedLength + 4);
  data.setUint32(0, encodedLength, Endian.big);
  var bytes = data.buffer.asUint8List();
  bytes.setRange(4, encodedLength + 4, encodedString);
  return bytes;
}
