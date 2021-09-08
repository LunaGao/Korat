import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/models/platform_client.dart';
import 'package:http/http.dart' as http;
import 'package:korat/models/project.dart';

class AliyunOSSClient extends PlatformClient {
  final ProjectModel projectModel;
  late String baseUrl;

  AliyunOSSClient(this.projectModel) {
    this.baseUrl = "http://${projectModel.bucket}.${projectModel.endPoint}/";
  }

  @override
  Future<ResponseModel<String>> putObject(ObjModel objModel) async {
    var headers = _getHeaders(
      'PUT',
      contentLength: objModel.value.length,
      filePath: objModel.fileFullNamePath,
      contentType: objModel.contentType,
      isPublic: objModel.isPublic,
    );
    var url = Uri.parse('${this.baseUrl}${objModel.fileFullNamePath}');
    try {
      var response = await http.put(
        url,
        headers: headers,
        body: objModel.value,
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        return ResponseModel<String>(
          isSuccess: true,
          message: response.body,
        );
      } else {
        return ResponseModel<String>(
          isSuccess: false,
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return ResponseModel<String>(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<ResponseModel<T>> getObject<T>(ObjModel objModel) async {
    var headers = _getHeaders(
      'GET',
      filePath: objModel.fileFullNamePath,
      contentType: objModel.contentType,
    );
    var url = Uri.parse('${this.baseUrl}${objModel.fileFullNamePath}');
    try {
      var response = await http.get(
        url,
        headers: headers,
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        if (T == Uint8List) {
          return ResponseModel<T>(
            isSuccess: true,
            message: (response.bodyBytes as T),
          );
        }
        return ResponseModel<T>(
          isSuccess: true,
          message: (response.body as T),
        );
      } else {
        return ResponseModel<T>(isSuccess: false, errorMessage: response.body);
      }
    } catch (e) {
      return ResponseModel<T>(isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<String>> deleteObject(ObjModel objModel) async {
    var headers = _getHeaders(
      'DELETE',
      filePath: objModel.fileFullNamePath,
    );
    var url = Uri.parse('${this.baseUrl}${objModel.fileFullNamePath}');
    try {
      var response = await http.delete(
        url,
        headers: headers,
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        return ResponseModel<String>(isSuccess: true, message: '');
      } else {
        return ResponseModel<String>(
            isSuccess: false, errorMessage: response.body);
      }
    } catch (e) {
      return ResponseModel<String>(
          isSuccess: false, errorMessage: e.toString());
    }
  }

  Map<String, String> _getHeaders(
    String httpMethod, {
    int contentLength = 0,
    String filePath = '',
    String contentType = '',
    bool isPublic = false,
  }) {
    var date = _httpDateNow();
    var authorization = _getAuthorization(
      this.projectModel.keyId,
      this.projectModel.keySecret,
      httpMethod,
      date,
      contentType: contentType,
      path: filePath,
      isPublic: isPublic,
    );
    var headers = {
      'x-oss-date': date,
      'Authorization': authorization,
      'Connection': 'keep-alive',
      'Content-Type': contentType,
    };
    if (isPublic) {
      headers.putIfAbsent("x-oss-object-acl", () => "public-read");
    }
    if (contentLength == 0) {
      headers.putIfAbsent(
          Headers.contentLengthHeader, () => contentLength.toString());
    }
    return headers;
  }

  String _getAuthorization(
    String keyId,
    String keySecret,
    String httpMethod,
    String date, {
    String path = '',
    String contentType = '',
    bool isPublic = false,
  }) {
    path = "/${projectModel.bucket}/" + path;
    String signature = "$httpMethod\n\n$contentType\n$date\nx-oss-date:$date\n";
    if (isPublic) {
      signature += "x-oss-object-acl:public-read\n";
    }
    signature += "$path";
    var hmac = new Hmac(sha1, utf8.encode(keySecret));
    var digest = hmac.convert(utf8.encode(signature));
    var returnSignature = base64Encode(digest.bytes);
    return "OSS " + keyId + ":" + returnSignature;
  }

  String _httpDateNow() {
    final dt = new DateTime.now();
    initializeDateFormatting();
    final formatter = new DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_ISO');
    final dts = formatter.format(dt.toUtc());
    return "$dts GMT";
  }
}
