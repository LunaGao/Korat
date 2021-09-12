import 'package:flutter/material.dart';
import 'package:korat/api/leancloud/report_api.dart';
import 'package:korat/common/global.dart';
import 'package:korat/models/report.dart';
import 'package:korat/pages/public/widgets/bottom_widget.dart';
import 'package:korat/routes/app_routes.dart';

class PublicReportsPage extends StatefulWidget {
  const PublicReportsPage({Key? key}) : super(key: key);

  @override
  _PublicReportsPageState createState() => _PublicReportsPageState();
}

class _PublicReportsPageState extends State<PublicReportsPage> {
  bool isUserSignin = false;
  bool isLoading = false;
  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() {
    if (Global.user == null) {
      isUserSignin = false;
    } else {
      isUserSignin = true;
    }
    setState(() {});
    ReportApi().getReports().then((reportsResponse) {
      if (reportsResponse.isSuccess) {
        reports = reportsResponse.message!;
        isLoading = true;
        setState(() {});
      } else {
        print(reportsResponse.errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoute.home,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "Korat",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "使用文档",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  "反馈列表",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          isUserSignin
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.signup)
                        .then((value) => updateUI());
                  },
                  child: Text(
                    "注册",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          isUserSignin
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.signin)
                        .then((value) => updateUI());
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          isUserSignin
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.dashboard);
                  },
                  child: Text(
                    "控制台",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: !isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    child: ListView.separated(
                      itemCount: reports.length,
                      itemBuilder: (buildContext, index) {
                        return ListTile(
                          leading: reports[index].isSolved
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                          title: Text(
                            reports[index].value,
                          ),
                        );
                      },
                      separatorBuilder: (context, build) => Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                  ),
          ),
          HomeBottomWidget(),
        ],
      ),
    );
  }
}
