import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:korat/api/leancloud/project_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/project.dart';
import 'package:korat/routes/app_routes.dart';

class ProjectEditorPage extends StatefulWidget {
  const ProjectEditorPage({Key? key}) : super(key: key);

  @override
  _ProjectEditorPageState createState() => _ProjectEditorPageState();
}

class _ProjectEditorPageState extends State<ProjectEditorPage> {
  bool _isLoading = true;
  String _title = '';
  List<String> platformList = [
    '请选择平台',
    PlatformConfig.aliyunOSS,
  ];
  ProjectEditorPageArguments? _arg;
  ProjectModel? _platformModel;
  String _selectedValue = '';
  var _nameTextEditingController = TextEditingController();
  var _dataBucketTextEditingController = TextEditingController();
  var _dataEndPointTextEditingController = TextEditingController();
  var _dataKeyIdTextEditingController = TextEditingController();
  var _dataKeySecretTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this._selectedValue = platformList[0];
  }

  void getData(String objectId) async {
    var response = await ProjectApi().getProjectById(objectId);
    if (response.isSuccess) {
      this._platformModel = response.message;
      this._selectedValue = this._platformModel!.platform;
      this._nameTextEditingController.text = this._platformModel!.name;
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
    var name = _nameTextEditingController.text;
    var endpoint = _dataEndPointTextEditingController.text;
    var bucket = _dataBucketTextEditingController.text;
    var accessKeyId = _dataKeyIdTextEditingController.text;
    var accessKeySecret = _dataKeySecretTextEditingController.text;
    if (name.isEmpty) {
      EasyLoading.showError("名称 不可为空哦");
      return;
    }
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
      var response = await ProjectApi().createProject(
        name,
        endpoint,
        bucket,
        accessKeyId,
        accessKeySecret,
        PlatformConfig.aliyunOSS,
        Global.user!.objectId,
      );
      if (response.isSuccess) {
        Navigator.of(context).pop<bool>(true);
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    } else {
      //更新
      var response = await ProjectApi().updateProject(
        this._platformModel!.objectId,
        name,
        endpoint,
        bucket,
        accessKeyId,
        accessKeySecret,
        PlatformConfig.aliyunOSS,
      );
      if (response.isSuccess) {
        if (_arg!.type == ProjectType.first) {
          Navigator.of(context).popAndPushNamed(AppRoute.dashboard);
        } else {
          Navigator.of(context).pop<bool>(true);
        }
      } else {
        EasyLoading.showError(response.errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_arg == null) {
      _arg = ModalRoute.of(context)!.settings.arguments
          as ProjectEditorPageArguments;
      switch (_arg!.type) {
        case ProjectType.create:
          this._title = "创建项目";
          _isLoading = false;
          break;
        case ProjectType.modify:
          this._title = "修改项目";
          getData(_arg!.projectModel!.objectId);
          break;
        case ProjectType.first:
          this._title = "创建项目";
          _isLoading = false;
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
        _inputBox(
          "名称",
          this._nameTextEditingController,
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
                  : getDisplayProjectNameFromString(value),
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

class ProjectEditorPageArguments {
  final ProjectType type;
  final ProjectModel? projectModel;

  ProjectEditorPageArguments(
    this.type, {
    this.projectModel,
  });
}

enum ProjectType {
  first,
  create,
  modify,
}
