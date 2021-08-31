import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/api/leancloud/platform_group_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/pages/platform/platform/platform_editor.dart';
import 'package:korat/pages/platform/platform_group/platform_group_editor.dart';
import 'package:korat/routes/app_routes.dart';

class PlatformGroupList extends StatefulWidget {
  const PlatformGroupList({Key? key}) : super(key: key);

  @override
  _PlatformGroupListState createState() => _PlatformGroupListState();
}

class _PlatformGroupListState extends State<PlatformGroupList> {
  bool _isLoading = true;
  List<PlatformGroup> platformGroups = [];
  List<PlatformModel> platforms = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var platformGroupsResponse =
        await PlatformGroupApi().getMyPlatformGroups(Global.user!.objectId);
    var platformsResponse =
        await PlatformApi().getMyPlatforms(Global.user!.objectId);
    if (platformGroupsResponse.isSuccess) {
      platformGroups = platformGroupsResponse.message!;
    } else {
      EasyLoading.showError(platformGroupsResponse.errorMessage);
    }
    if (platformsResponse.isSuccess) {
      platforms = platformsResponse.message!;
    } else {
      EasyLoading.showError(platformsResponse.errorMessage);
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "平台组管理",
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                  AppRoute.platform_group_editor,
                  arguments: PlatformGroupPageArguments(
                    PlatformGroupType.create,
                  ),
                )
                    .then<bool?>((value) {
                  if (value != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    getData();
                  }
                });
              },
              child: Text(
                "添加平台组",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                  AppRoute.platform_editor,
                  arguments: PlatformPageArguments(
                    PlatformType.create,
                  ),
                )
                    .then<bool?>((value) {
                  if (value != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    getData();
                  }
                });
              },
              child: Text(
                "添加平台",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: mainBody(),
    );
  }

  void removePlatformGroup(int index) {
    showOkCancelAlertDialog(
      title: "是否删除此平台组？删除后无法找回",
      context: context,
    ).then((value) async {
      if (value == OkCancelResult.ok) {
        var result = await PlatformGroupApi()
            .deletePlatformGroup(platformGroups[index].objectId);
        if (result.isSuccess) {
          getData();
          EasyLoading.showSuccess("删除成功");
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  void removePlatform(int index) {
    showOkCancelAlertDialog(
      title: "是否删除此平台？删除后无法找回",
      context: context,
    ).then((value) async {
      if (value == OkCancelResult.ok) {
        var result = await PlatformApi()
            .deleteAliyunOSSPlatform(platforms[index].objectId);
        if (result.isSuccess) {
          getData();
          EasyLoading.showSuccess("删除成功");
        } else {
          print(result.errorMessage);
          EasyLoading.showError(result.errorMessage);
        }
      }
    });
  }

  Widget mainBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: platformGroups.length + platforms.length + 2,
              itemBuilder: (buildContext, index) {
                if (index < platformGroups.length + 1) {
                  return _platformGroupItem(
                    index,
                  );
                } else {
                  return _platformItem(
                    index - platformGroups.length - 1,
                  );
                }
              },
            ),
    );
  }

  Widget _platformGroupItem(int index) {
    if (index == 0) {
      return ListTile(
        title: Text(
          "平台组",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => removePlatformGroup(index - 1),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(
          AppRoute.platform_group_editor,
          arguments: PlatformGroupPageArguments(
            PlatformGroupType.modify,
            platformGroup: platformGroups[index - 1],
          ),
        )
            .then<bool?>((value) {
          if (value != null) {
            setState(() {
              _isLoading = true;
            });
            getData();
          }
        });
        ;
      },
      title: Text(
        platformGroups[index - 1].name,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: new Border.all(width: 1, color: Colors.green),
            ),
            child: Text(
              "数据平台：" +
                  getDisplayPlatformNameFromString(
                      platformGroups[index - 1].dataPlatform?.platform),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: new Border.all(width: 1, color: Colors.blue),
            ),
            child: Text(
              "发布平台：" +
                  getDisplayPlatformNameFromString(
                      platformGroups[index - 1].publishPlatform?.platform),
            ),
          ),
        ],
      ),
    );
  }

  Widget _platformItem(int index) {
    if (index == 0) {
      return ListTile(
        title: Text(
          "平台",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => removePlatform(index - 1),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(
          AppRoute.platform_editor,
          arguments: PlatformPageArguments(
            PlatformType.modify,
            platformModel: platforms[index - 1],
          ),
        )
            .then<bool?>((value) {
          if (value != null) {
            setState(() {
              _isLoading = true;
            });
            getData();
          }
        });
      },
      title: Text(
        platforms[index - 1].objectId,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: new Border.all(width: 1, color: Colors.green),
            ),
            child: Text(
              "平台：" +
                  getDisplayPlatformNameFromString(
                      platforms[index - 1].platform),
            ),
          ),
        ],
      ),
    );
  }
}
