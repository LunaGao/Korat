import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_group_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/platform_group.dart';

class PlatformGroupEditorPage extends StatefulWidget {
  const PlatformGroupEditorPage({Key? key}) : super(key: key);

  @override
  _PlatformGroupEditorPageState createState() =>
      _PlatformGroupEditorPageState();
}

class _PlatformGroupEditorPageState extends State<PlatformGroupEditorPage> {
  String _title = '';
  List<String> platformList = [
    '请选择平台',
    PlatformConfig.aliyunOSS,
  ];
  PlatformGroupPageArguments? _arg;
  String _dataSelectedValue = '';
  String _publishSelectedValue = '';
  PlatformGroup _platformGroup = PlatformGroup('');
  bool _isFirstJoinIn = false;
  TextEditingController _groupNameTextEditingController =
      TextEditingController();
  TextEditingController _dataBucketTextEditingController =
      TextEditingController();
  TextEditingController _dataEndPointTextEditingController =
      TextEditingController();
  TextEditingController _dataKeyIdTextEditingController =
      TextEditingController();
  TextEditingController _dataKeySecretTextEditingController =
      TextEditingController();
  TextEditingController _publishBucketTextEditingController =
      TextEditingController();
  TextEditingController _publishEndPointTextEditingController =
      TextEditingController();
  TextEditingController _publishKeyIdTextEditingController =
      TextEditingController();
  TextEditingController _publishKeySecretTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    this._dataSelectedValue = platformList[0];
    this._publishSelectedValue = platformList[0];
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
            this._dataSelectedValue =
                this._platformGroup.dataPlatform!.platform;
            this._dataBucketTextEditingController.text =
                this._platformGroup.dataPlatform!.bucket;
            this._dataEndPointTextEditingController.text =
                this._platformGroup.dataPlatform!.endPoint;
            this._dataKeyIdTextEditingController.text =
                this._platformGroup.dataPlatform!.keyId;
            this._dataKeySecretTextEditingController.text =
                this._platformGroup.dataPlatform!.keySecret;
          }
          if (this._platformGroup.publishPlatform != null) {
            this._publishSelectedValue =
                this._platformGroup.publishPlatform!.platform;
            this._publishBucketTextEditingController.text =
                this._platformGroup.publishPlatform!.bucket;
            this._publishEndPointTextEditingController.text =
                this._platformGroup.publishPlatform!.endPoint;
            this._publishKeyIdTextEditingController.text =
                this._platformGroup.publishPlatform!.keyId;
            this._publishKeySecretTextEditingController.text =
                this._platformGroup.publishPlatform!.keySecret;
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
        _dropDownButton(
          0,
        ),
        _dataSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Bucket",
                this._dataBucketTextEditingController,
              ),
        _dataSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "End point",
                this._dataEndPointTextEditingController,
              ),
        _dataSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Id",
                this._dataKeyIdTextEditingController,
              ),
        _dataSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Secret",
                this._dataKeySecretTextEditingController,
              ),
      ],
    );
  }

  List<Widget> _step3() {
    return _group(
      '添加发布平台',
      [
        _dropDownButton(
          1,
        ),
        this._publishSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Bucket",
                this._publishBucketTextEditingController,
              ),
        this._publishSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "End point",
                this._publishEndPointTextEditingController,
              ),
        this._publishSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Id",
                this._publishKeyIdTextEditingController,
              ),
        this._publishSelectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Secret",
                this._publishKeySecretTextEditingController,
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
        items: this.platformList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value == '请选择平台'
                  ? '请选择平台'
                  : getDisplayPlatformNameFromString(value),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
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
