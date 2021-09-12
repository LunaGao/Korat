import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/models/report.dart';

class ReportApi {
  Future<ResponseModel<ReportModel>> getReportById(String objectId) async {
    var response = await BaseApi().get('/classes/Report/$objectId', {});

    return _getReport(response);
  }

  Future<ResponseModel<List<ReportModel>>> getReports() async {
    var response = await BaseApi().get(
      '/classes/Report',
      {},
    );
    return _getListForReport(response);
  }

  Future<ResponseModel> createReport(
    String value,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/Report',
      {
        'value': value,
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  ResponseModel<List<ReportModel>> _getListForReport(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<List<ReportModel>> returnValue =
        ResponseModel<List<ReportModel>>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    List<ReportModel> data = [];
    for (Map item in response.message["results"]) {
      var report = ReportModel();
      report.objectId = item['objectId'];
      report.answer = item['answer'];
      report.isSolved = item['isSolved'];
      report.value = item['value'];
      data.add(report);
    }
    returnValue.message = data;
    return returnValue;
  }

  ResponseModel<ReportModel> _getReport(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<ReportModel> returnValue = ResponseModel<ReportModel>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    var item = response.message;
    var report = ReportModel();
    report.objectId = item['objectId'];
    report.objectId = item['objectId'];
    report.answer = item['answer'];
    report.isSolved = item['isSolved'];
    report.value = item['value'];
    returnValue.message = report;
    return returnValue;
  }
}
