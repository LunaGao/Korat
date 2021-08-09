import 'package:dio/dio.dart';
import 'package:korat/api/base_model/base_model.dart';
import 'package:korat/api/leancloud/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  Future<ApiResponseModel> get(String url, Map<String, dynamic> data) async {
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
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel> post(String url, dynamic data) async {
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
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel> getWithAuth(
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
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel> postWithAuth(String url, dynamic data) async {
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
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(
          isSuccess: false, errorMessage: e.response!.data['error']);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
    }
  }
}
