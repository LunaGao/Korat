import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/post_item.dart';

class AliyunOSSClient extends PlatformClient {
  final PlatformModel platformModel;
  late String baseUrl;

  AliyunOSSClient(this.platformModel) {
    this.baseUrl = "http://${platformModel.bucket}.${platformModel.endPoint}/";
  }

  @override
  Future<ResponseModel<PostConfig>> getPostConfig() async {
    String fileFullPathName = "korat/post/post.json";
    var options = _getOptions(
      'GET',
      file: fileFullPathName,
      contentType: "application/json;charset=utf-8",
    );
    try {
      var response = await Dio().get(
        "${this.baseUrl}$fileFullPathName",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<PostConfig>(
          isSuccess: true,
          message: PostConfig.fromJson(jsonDecode(response.data as String)),
        );
      } else {
        return ResponseModel<PostConfig>(
          isSuccess: false,
          errorMessage: "",
        );
      }
    } on DioError catch (e) {
      return ResponseModel<PostConfig>(
        isSuccess: false,
        errorMessage: e.response!.data,
      );
    } catch (e) {
      return ResponseModel<PostConfig>(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel<String>> putPostConfig(String value) async {
    String fileFullPathName = "korat/post/post.json";
    var options = _getOptions(
      'PUT',
      file: fileFullPathName,
      contentType: "text/plain;charset=utf-8",
    );
    try {
      var response = await Dio().put(
        "${this.baseUrl}$fileFullPathName",
        options: options,
        data: value,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<String>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<String>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<String>> putObject(
    String fileNamePath,
    dynamic value, {
    String contentType = "text/plain;charset=utf-8",
  }) async {
    var options = _getOptions(
      'PUT',
      file: fileNamePath,
      contentType: contentType,
    );
    try {
      var response = await Dio().put(
        "${this.baseUrl}$fileNamePath",
        options: options,
        data: value,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<String>(isSuccess: true, message: response.data);
      } else {
        return ResponseModel<String>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<T>> getObject<T>(
    String path, {
    String contentType = "text/plain;charset=utf-8",
  }) async {
    var options = _getOptions(
      'GET',
      file: path,
      contentType: contentType,
    );
    try {
      var response = await Dio().get(
        "${this.baseUrl}$path",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<T>(
          isSuccess: true,
          message: (response.data as T),
        );
      } else {
        return ResponseModel<T>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<T>(isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<T>(isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<PostItem>> getPostObject(Post post) async {
    var options = _getOptions(
      'GET',
      file: post.fileFullNamePath,
      contentType: "text/plain;charset=utf-8",
    );
    try {
      var response = await Dio().get(
        "${this.baseUrl}${post.fileFullNamePath}",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        PostItem returnPostItem = PostItem(
          post.fileFullNamePath,
          value: (response.data as String).trimRight(),
        );
        return ResponseModel<PostItem>(
            isSuccess: true, message: returnPostItem);
      } else {
        return ResponseModel<PostItem>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<PostItem>(
          isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<PostItem>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<String>> deleteObject(String fileFullNamePath) async {
    var options = _getOptions(
      'DELETE',
      file: fileFullNamePath,
    );
    try {
      var response = await Dio().delete(
        "${this.baseUrl}$fileFullNamePath",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<String>(isSuccess: true, message: '');
      } else {
        return ResponseModel<String>(
            isSuccess: false, errorMessage: response.data);
      }
    } on DioError catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  void setPlatformModel(PlatformModel platformModel) {}

  @override
  PlatformModel getPlatformModel() {
    return this.platformModel;
  }

  Options _getOptions(
    String httpMethod, {
    String file = '',
    String contentType = '',
  }) {
    var date = httpDateNow();
    var authorization = getAuthorization(
      this.platformModel.keyId,
      this.platformModel.keySecret,
      httpMethod,
      date,
      contentType: contentType,
      path: file,
    );
    var headers = {
      'x-oss-date': date,
      'Authorization': authorization,
      'Connection': 'keep-alive',
      'Content-Type': contentType,
    };

    return Options(
      headers: headers,
    );
  }

  String getAuthorization(
    String keyId,
    String keySecret,
    String httpMethod,
    String date, {
    String path = '',
    String contentType = '',
  }) {
    path = "/${platformModel.bucket}/" + path;
    String signature =
        "$httpMethod\n\n$contentType\n$date\nx-oss-date:$date\n$path";
    var hmac = new Hmac(sha1, utf8.encode(keySecret));
    var digest = hmac.convert(utf8.encode(signature));
    var returnSignature = base64Encode(digest.bytes);
    return "OSS " + keyId + ":" + returnSignature;
  }

  String httpDateNow() {
    final dt = new DateTime.now();
    initializeDateFormatting();
    final formatter = new DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_ISO');
    final dts = formatter.format(dt.toUtc());
    return "$dts GMT";
  }
}
