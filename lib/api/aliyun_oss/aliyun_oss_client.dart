import 'package:dio/dio.dart';
import 'package:korat/api/aliyun_oss/utils.dart';
import 'package:korat/api/base_model/post.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_client.dart';
import 'package:xml/xml.dart';

class AliyunOSSClient extends PlatformClient {
  final PlatformModel platformModel;
  late String baseUrl;

  AliyunOSSClient(this.platformModel) {
    this.baseUrl = "http://${platformModel.bucket}.${platformModel.endPoint}/";
  }

  @override
  Future<ResponseModel<List<Post>>> listObjects() async {
    var options = _getOptions('GET');
    try {
      var response = await Dio().get(
        "${this.baseUrl}?list-type=2&prefix=korat/",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ResponseModel<List<Post>>(
          isSuccess: true,
          message: _getPostList(response.data),
        );
      } else {
        return ResponseModel<List<Post>>(
          isSuccess: false,
          errorMessage: "",
        );
      }
    } on DioError catch (e) {
      return ResponseModel<List<Post>>(
        isSuccess: false,
        errorMessage: e.response!.data,
      );
    } catch (e) {
      return ResponseModel<List<Post>>(
        isSuccess: false,
        errorMessage: e.toString(),
      );
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
  Future<ResponseModel<Post>> getObject(Post post) async {
    var options = _getOptions(
      'GET',
      file: post.fileName,
      contentType: "text/plain;charset=utf-8",
    );
    try {
      var response = await Dio().get(
        "${this.baseUrl}${post.fileName}",
        options: options,
      );
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        Post returnPost = Post(
          post.fileName,
          post.displayFileName,
          post.lastModified,
          value: (response.data as String).trimRight(),
        );
        return ResponseModel<Post>(isSuccess: true, message: returnPost);
      } else {
        return ResponseModel<Post>(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ResponseModel<Post>(
          isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ResponseModel<Post>(isSuccess: false, errorMessage: e.toString());
    }
  }

  @override
  Future<ResponseModel<String>> deleteObject(Post post) async {
    var options = _getOptions(
      'DELETE',
      file: post.fileName,
    );
    try {
      var response = await Dio().delete(
        "${this.baseUrl}${post.fileName}",
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

  List<Post> _getPostList(String xmlData) {
    List<Post> returnValue = [];
    var document = XmlDocument.parse(xmlData);
    var keyCount = document.findAllElements('KeyCount').first;
    var keyCountText = keyCount.text;
    int keyCountInt = int.parse(keyCountText);
    if (keyCountInt > 0) {
      var contents = document.findAllElements('Contents');
      for (var content in contents) {
        var fileName = content.getElement('Key')!.text;
        var displayFileName = fileName.substring(6, fileName.length - 3);
        var lastModified = content.getElement('LastModified')!.text;
        returnValue.add(
          Post(
            fileName,
            displayFileName,
            lastModified,
          ),
        );
      }
    }
    return returnValue;
  }
}
