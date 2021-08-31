import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';

class PlatformEditor extends StatefulWidget {
  const PlatformEditor({Key? key}) : super(key: key);

  @override
  _PlatformEditorState createState() => _PlatformEditorState();
}

class _PlatformEditorState extends State<PlatformEditor> {
  String _title = '';
  List<String> platformList = [
    '请选择平台',
    PlatformConfig.aliyunOSS,
  ];
  PlatformPageArguments? _arg;
  PlatformModel? _platformModel;
  String _selectedValue = '';
  TextEditingController _dataBucketTextEditingController =
      TextEditingController();
  TextEditingController _dataEndPointTextEditingController =
      TextEditingController();
  TextEditingController _dataKeyIdTextEditingController =
      TextEditingController();
  TextEditingController _dataKeySecretTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    this._selectedValue = platformList[0];
  }

  void finished() async {
    if (_selectedValue == '请选择平台') {
      EasyLoading.showError("没有找到要保存的内容哦");
      return;
    }
    // if (this._platformGroup.objectId.isEmpty) {
    //   //创建
    //   var nameResponse = await PlatformGroupApi().createPlatformName(
    //     this._groupNameTextEditingController.text,
    //     Global.user!.objectId,
    //   );
    //   Navigator.of(context).pop();
    // } else {
    //   //更新
    //   Navigator.of(context).pop();
    // }
    // var nameResponse = await PlatformGroupApi().putPlatformName(
    //   this._groupNameTextEditingController.text,
    //   Global.user!.objectId,
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg =
          ModalRoute.of(context)!.settings.arguments as PlatformPageArguments;
      switch (_arg!.type) {
        case PlatformType.create:
          this._title = "创建平台";
          break;
        case PlatformType.modify:
          this._title = "修改平台";
          this._platformModel = _arg!.platformModel!;
          this._selectedValue = this._platformModel!.platform;
          this._dataBucketTextEditingController.text =
              this._platformModel!.bucket;
          this._dataEndPointTextEditingController.text =
              this._platformModel!.endPoint;
          this._dataKeyIdTextEditingController.text =
              this._platformModel!.keyId;
          this._dataKeySecretTextEditingController.text =
              this._platformModel!.keySecret;
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
          ..._platformContent(),
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

  List<Widget> _platformContent() {
    return _group(
      '平台',
      [
        this._platformModel?.objectId == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Id: " + this._platformModel!.objectId,
                ),
              ),
        _dropDownButton(
          0,
        ),
        _selectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Bucket",
                this._dataBucketTextEditingController,
              ),
        _selectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "End point",
                this._dataEndPointTextEditingController,
              ),
        _selectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Id",
                this._dataKeyIdTextEditingController,
              ),
        _selectedValue == '请选择平台'
            ? Container()
            : _inputBox(
                "Key Secret",
                this._dataKeySecretTextEditingController,
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
        value: _selectedValue,
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
            _selectedValue = value!;
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

class PlatformPageArguments {
  final PlatformType type;
  final PlatformModel? platformModel;

  PlatformPageArguments(
    this.type, {
    this.platformModel,
  });
}

enum PlatformType {
  create,
  modify,
}
