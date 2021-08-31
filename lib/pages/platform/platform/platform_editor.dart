import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/platform_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';

class PlatformEditor extends StatefulWidget {
  const PlatformEditor({Key? key}) : super(key: key);

  @override
  _PlatformEditorState createState() => _PlatformEditorState();
}

class _PlatformEditorState extends State<PlatformEditor> {
  bool _isLoading = true;
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

  void getData(String objectId) async {
    var response = await PlatformApi().getPlatformById(objectId);
    if (response.isSuccess) {
      this._platformModel = response.message;
      this._selectedValue = this._platformModel!.platform;
      this._dataBucketTextEditingController.text = this._platformModel!.bucket;
      this._dataEndPointTextEditingController.text =
          this._platformModel!.endPoint;
      this._dataKeyIdTextEditingController.text = this._platformModel!.keyId;
      this._dataKeySecretTextEditingController.text =
          this._platformModel!.keySecret;
      _isLoading = false;
      setState(() {});
    } else {
      EasyLoading.showError(response.errorMessage);
    }
  }

  void finished() async {
    if (_selectedValue == '请选择平台') {
      EasyLoading.showError("没有找到要保存的内容哦");
      return;
    }
    var endpoint = _dataEndPointTextEditingController.text;
    var bucket = _dataBucketTextEditingController.text;
    var accessKeyId = _dataKeyIdTextEditingController.text;
    var accessKeySecret = _dataKeySecretTextEditingController.text;
    if (endpoint.isEmpty) {
      EasyLoading.showError("End Point 不可为空哦");
      return;
    }
    if (bucket.isEmpty) {
      EasyLoading.showError("bucket 不可为空哦");
      return;
    }
    if (accessKeyId.isEmpty) {
      EasyLoading.showError("accessKeyId 不可为空哦");
      return;
    }
    if (accessKeySecret.isEmpty) {
      EasyLoading.showError("accessKeySecret 不可为空哦");
      return;
    }
    if (this._platformModel == null) {
      //创建
      var response = await PlatformApi().createAliyunOSSPlatform(
        endpoint,
        bucket,
        accessKeyId,
        accessKeySecret,
        Global.user!.objectId,
      );
      if (response.isSuccess) {
        Navigator.of(context).pop<bool>(true);
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } else {
      //更新
      var response = await PlatformApi().updateAliyunOSSPlatform(
        this._platformModel!.objectId,
        endpoint,
        bucket,
        accessKeyId,
        accessKeySecret,
      );
      if (response.isSuccess) {
        Navigator.of(context).pop<bool>(true);
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg =
          ModalRoute.of(context)!.settings.arguments as PlatformPageArguments;
      switch (_arg!.type) {
        case PlatformType.create:
          this._title = "创建平台";
          _isLoading = false;
          break;
        case PlatformType.modify:
          this._title = "修改平台";
          getData(_arg!.platformModel!.objectId);
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : mainBody(),
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
