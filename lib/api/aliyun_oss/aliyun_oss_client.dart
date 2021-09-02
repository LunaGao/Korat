import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:korat/api/aliyun_oss/utils.dart';
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
      String fileNamePath, String value) async {
    var options = _getOptions(
      'PUT',
      file: fileNamePath,
      contentType: "text/plain;charset=utf-8",
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
}
