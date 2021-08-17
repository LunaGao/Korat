import 'package:flutter/material.dart';
import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/platform_group_api.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/routes/app_routes.dart';

class PlatformGroupEditorPage extends StatefulWidget {
  const PlatformGroupEditorPage({Key? key}) : super(key: key);

  @override
  _PlatformGroupEditorPageState createState() =>
      _PlatformGroupEditorPageState();
}

class _PlatformGroupEditorPageState extends State<PlatformGroupEditorPage> {
  String _title = '';
  PlatformGroup _platformGroup = PlatformGroup('');
  bool _isFirstJoinIn = false;
  late User _user;
  int _currentIndex = 0;
  bool _complateStep0 = false;
  TextEditingController _step1TextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void nextStep() async {
    if (this._currentIndex == 0) {
      if (this._complateStep0) {
        goToStep(this._currentIndex + 1);
      } else {
        var nameResponse = await PlatformGroupApi().putPlatformName(
          this._step1TextEditingController.text,
          this._user.objectId,
        );
      }
    } else {
      this._currentIndex != 2 ? goToStep(this._currentIndex + 1) : finished();
    }
  }

  void finished() {
    Navigator.of(context).pushReplacementNamed(AppRoute.dashboard);
  }

  void cancel() {
    if (this._currentIndex > 0) {
      goToStep(this._currentIndex - 1);
    }
  }

  void goToStep(int stepIndex) {
    setState(() {
      this._currentIndex = stepIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as PlatformGroupPageArguments;
    switch (args.type) {
      case PlatformGroupType.create:
        this._title = "创建平台组";
        break;
      case PlatformGroupType.modify:
        this._title = "修改平台组";
        this._complateStep0 = true;
        this._platformGroup = args.platformGroup!;
        this._step1TextEditingController.text = this._platformGroup.name;
        break;
      case PlatformGroupType.first:
        this._title = "创建平台组";
        this._isFirstJoinIn = true;
        break;
    }
    this._user = args.user;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this._isFirstJoinIn
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "首次登录平台，需要设置平台组才能使用后续功能",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            : Container(),
        Stepper(
          currentStep: this._currentIndex,
          onStepCancel: cancel,
          onStepContinue: nextStep,
          onStepTapped: (stepIndex) => goToStep(stepIndex),
          steps: this._getSteps(),
        ),
      ],
    );
  }

  List<Step> _getSteps() {
    return [
      _step1(),
      _step2(),
      _step3(),
    ];
  }

  Step _step1() {
    return Step(
      title: Text('请输入平台组名字'),
      content: Container(
        alignment: Alignment.centerLeft,
        child: _complateStep0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _platformGroup.name,
                  ),
                  IconButton(
                    onPressed: () {
                      //TODO: 这里不能变
                      setState(() {
                        this._complateStep0 = false;
                        this._currentIndex = 0;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  )
                ],
              )
            : Container(
                width: 500,
                child: TextFormField(
                  controller: this._step1TextEditingController,
                  maxLines: 1,
                ),
              ),
      ),
    );
  }

  Step _step2() {
    return Step(
      title: Text('添加数据平台'),
      content: Text('Content for Step 2'),
    );
  }

  Step _step3() {
    return Step(
      title: Text('添加发布平台'),
      content: Text('Content for Step 2'),
    );
  }
}

class PlatformGroupPageArguments {
  final PlatformGroupType type;
  final User user;
  final PlatformGroup? platformGroup;

  PlatformGroupPageArguments(
    this.type,
    this.user, {
    this.platformGroup,
  });
}

enum PlatformGroupType {
  create,
  modify,
  first,
}
