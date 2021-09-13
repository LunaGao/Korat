import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBottomWidget extends StatelessWidget {
  const HomeBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bottomGroup('关于', [
            LinkItem(
              "使用文档",
              "https://help.aliyun.com/product/31815.html",
            ),
            LinkItem(
              "反馈列表",
              "https://help.aliyun.com/product/31815.html",
            ),
            LinkItem(
              "开源地址",
              "https://github.com/LunaGao/Korat",
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
          bottomGroup('支持平台', [
            LinkItem(
              "阿里云对象存储OSS",
              "https://help.aliyun.com/product/31815.html",
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomGroup(
    String title,
    List<LinkItem> lists,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 40, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ...groupList(lists),
        ],
      ),
    );
  }

  List<Widget> groupList(List<LinkItem> lists) {
    List<Widget> returnValue = [];
    for (LinkItem item in lists) {
      returnValue.add(
        Container(
          height: 22,
          child: TextButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(1, 1)),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () async {
              await canLaunch(item.url)
                  ? await launch(item.url)
                  : throw 'Could not launch ${item.url}';
            },
            child: Text(
              item.displayTitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }
    return returnValue;
  }
}

class LinkItem {
  String displayTitle;
  String url;

  LinkItem(this.displayTitle, this.url);
}
