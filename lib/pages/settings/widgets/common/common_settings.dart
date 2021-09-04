import 'package:flutter/material.dart';

List<Widget> group(String title, List<Widget> content) {
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

Widget inputBox(String title, TextEditingController textEditingController) {
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
  return TextButton(
    child: Text("保存"),
    onPressed: () {
      callback();
    },
  );
}
