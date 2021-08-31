import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/api/leancloud/platform_group_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/pages/platform/platform/platform_editor.dart';
import 'package:korat/routes/app_routes.dart';

class PlatformGroupEditorPage extends StatefulWidget {
  const PlatformGroupEditorPage({Key? key}) : super(key: key);

  @override
  _PlatformGroupEditorPageState createState() =>
      _PlatformGroupEditorPageState();
}

class _PlatformGroupEditorPageState extends State<PlatformGroupEditorPage> {
  bool _isLoading = true;
  String _title = '';
  String _defaultPlatformItem = '请选择平台';
  String _addPlatformItem = '创建平台';
  List<PlatformModel> platforms = [];
  List<String> platformDisplayList = [];
  PlatformGroupPageArguments? _arg;
  String _dataSelectedValue = '';
  String _publishSelectedValue = '';
  PlatformGroup _platformGroup = PlatformGroup('');
  bool _isFirstJoinIn = false;
  TextEditingController _groupNameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    this._dataSelectedValue = _defaultPlatformItem;
    this._publishSelectedValue = _defaultPlatformItem;
    getData();
  }

  void getData() async {
    var platformsResponse =
        await PlatformApi().getMyPlatforms(Global.user!.objectId);
    if (platformsResponse.isSuccess) {
      platforms = platformsResponse.message!;
      platformDisplayList.clear();
      platformDisplayList.add(_defaultPlatformItem);
      platformDisplayList.addAll(platforms
          .map<String>((e) => getDropDownItemString(e.objectId, e.platform)));
      platformDisplayList.add(_addPlatformItem);
      setState(() {
        _isLoading = false;
      });
    } else {
      EasyLoading.showError(platformsResponse.errorMessage);
    }
  }

  void finished() async {
    String name = _groupNameTextEditingController.text;
    if (name.isEmpty) {
      EasyLoading.showError("平台组名称是必填的哦");
      return;
    }
    if (_dataSelectedValue == '请选择平台') {
      EasyLoading.showError("数据平台是必须要配置的哦");
      return;
    }
    if (this._platformGroup.objectId.isEmpty) {
      //创建
      var nameResponse = await PlatformGroupApi().createPlatformName(
        this._groupNameTextEditingController.text,
        Global.user!.objectId,
      );
      Navigator.of(context).pop();
    } else {
      //更新
      Navigator.of(context).pop();
    }
    // var nameResponse = await PlatformGroupApi().putPlatformName(
    //   this._groupNameTextEditingController.text,
    //   Global.user!.objectId,
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg = ModalRoute.of(context)!.settings.arguments
          as PlatformGroupPageArguments;
      switch (_arg!.type) {
        case PlatformGroupType.create:
          this._title = "创建平台组";
          break;
        case PlatformGroupType.modify:
          this._title = "修改平台组";
          this._platformGroup = _arg!.platformGroup!;
          this._groupNameTextEditingController.text = this._platformGroup.name;
          if (this._platformGroup.dataPlatform != null) {
            this._dataSelectedValue = getDropDownItemString(
                this._platformGroup.dataPlatform!.objectId,
                this._platformGroup.dataPlatform!.platform);
          }
          if (this._platformGroup.publishPlatform != null) {
            this._publishSelectedValue = getDropDownItemString(
                this._platformGroup.publishPlatform!.objectId,
                this._platformGroup.publishPlatform!.platform);
          }
          break;
        case PlatformGroupType.first:
          this._title = "创建平台组";
          this._isFirstJoinIn = true;
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
        ),
      ),
      body: mainBody(),
    );
  }

  Widget mainBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._isFirstJoinIn
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "首次登录平台，需要设置平台组才能使用后续功能（至少要设置数据平台）",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
          ..._step1(),
          ..._step2(),
          ..._step3(),
          TextButton(
            onPressed: () {
              finished();
            },
            child: Text("保存"),
          ),
        ],
      ),
    );
  }

  List<Widget> _step1() {
    return _group(
      '平台组名字',
      [
        _inputBox(
          "名称",
          this._groupNameTextEditingController,
        ),
      ],
    );
  }

  List<Widget> _step2() {
    return _group(
      '添加数据平台',
      [
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _dropDownButton(
                0,
              ),
      ],
    );
  }

  List<Widget> _step3() {
    return _group(
      '添加发布平台',
      [
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _dropDownButton(
                1,
              ),
      ],
    );
  }

  List<Widget> _group(String title, List<Widget> content) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ...content,
      SizedBox(
        height: 20.0,
      ),
    ];
  }

  Widget _dropDownButton(
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: index == 0 ? _dataSelectedValue : _publishSelectedValue,
        items: this
            .platformDisplayList
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          if (value == _addPlatformItem) {
            Navigator.of(context).pushNamed(
              AppRoute.platform_editor,
              arguments: PlatformPageArguments(
                PlatformType.create,
              ),
            );
            return;
          }
          setState(() {
            index == 0
                ? _dataSelectedValue = value!
                : _publishSelectedValue = value!;
          });
        },
      ),
    );
  }

  Widget _inputBox(String title, TextEditingController textEditingController) {
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

  String getDropDownItemString(String objectId, String platform) {
    return objectId + " [" + getDisplayPlatformNameFromString(platform) + "]";
  }
}

class PlatformGroupPageArguments {
  final PlatformGroupType type;
  final PlatformGroup? platformGroup;

  PlatformGroupPageArguments(
    this.type, {
    this.platformGroup,
  });
}

enum PlatformGroupType {
  create,
  modify,
  first,
}
