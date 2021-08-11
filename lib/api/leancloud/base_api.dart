import 'package:dio/dio.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  Future<ResponseModel<dynamic>> get(
      String url, Map<String, dynamic> data) async {
    var options = Options(
      headers: {
        'X-LC-Id': apiAppId,
        'X-LC-Key': apiAppKey,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    );
    try {
      var response = await Dio().get(
        apiBaseUrl + url,
        options: options,
        queryParameters: data,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<dynamic>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<dynamic>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ResponseModel<dynamic>> post(String url, dynamic data) async {
    var options = Options(
      headers: {
        'X-LC-Id': apiAppId,
        'X-LC-Key': apiAppKey,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    );
    try {
      var response = await Dio().post(
        apiBaseUrl + url,
        data: data,
        options: options,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<dynamic>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<dynamic>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ResponseModel<dynamic>> getWithAuth(
      String url, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var options = Options(
      headers: {
        'X-LC-Id': apiAppId,
        'X-LC-Key': apiAppKey,
        'X-LC-Session': prefs.getString('sessionToken'),
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    );
    try {
      var response = await Dio().get(
        apiBaseUrl + url,
        options: options,
        queryParameters: data,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<dynamic>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<dynamic>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ResponseModel<dynamic>> postWithAuth(String url, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var options = Options(
      headers: {
        'X-LC-Id': apiAppId,
        'X-LC-Key': apiAppKey,
        'X-LC-Session': prefs.getString('sessionToken'),
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    );
    try {
      var response = await Dio().post(
        apiBaseUrl + url,
        data: data,
        options: options,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<dynamic>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<dynamic>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ResponseModel<dynamic>(
          isSuccess: false, errorMessage: e.toString());
    }
  }
}
