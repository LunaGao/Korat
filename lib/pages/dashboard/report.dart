import 'package:flutter/material.dart';
import 'package:korat/api/leancloud/report_api.dart';
import 'package:korat/common/global.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "意见、建议或Bug 反馈",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                await ReportApi().createReport(
                  textEditingController.text,
                  Global.user!.objectId,
                );
                Navigator.pop(context, true);
              },
              child: Text(
                "提交反馈",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: "请输入您的宝贵意见、建议或Bug",
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
