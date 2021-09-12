import 'package:flutter/material.dart';

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
          bottomGroup('支持平台', [
            LinkItem(
              "阿里云对象存储OSS",
              "https://help.aliyun.com/product/31815.html",
            )
          ]),
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
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
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
        Text(
          item.displayTitle,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
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
