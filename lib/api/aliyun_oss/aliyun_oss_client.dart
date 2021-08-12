import 'package:dio/dio.dart';
import 'package:korat/api/aliyun_oss/utils.dart';
import 'package:korat/api/base_model/post.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:xml/xml.dart';

class AliyunOSSClient {
  late String endpoint;
  late String accessKey;
  late String accessSecret;
  late String bucket;

  AliyunOSSClient(
      String accessKey, String accessSecret, String endpoint, String bucket) {
    this.endpoint = endpoint;
    this.accessKey = accessKey;
    this.accessSecret = accessSecret;
    this.bucket = bucket;
  }

  Future<ResponseModel<List<Post>>> listObjects() async {
    var options = _getOptions('GET');
    try {
      var response = await Dio().get(
        "http://$bucket.$endpoint/?list-type=2&prefix=korat/",
        options: options,
      );
      print(response);
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

  Future<ResponseModel<String>> putObject() async {
    var fileName = "korat/hello.md";
    var options = _getOptions(
      'PUT',
      file: fileName,
      contentType: "text/plain",
    );
    try {
      var response = await Dio().put(
        "http://$bucket.$endpoint/$fileName",
        options: options,
        data: "hello 123123 aaa",
      );
      print(response);
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

  Future<ResponseModel<Post>> getObject(Post post) async {
    var options = _getOptions(
      'GET',
      file: post.fileName,
      contentType: "text/plain",
    );
    try {
      var response = await Dio().get(
        "http://$bucket.$endpoint/${post.fileName}",
        options: options,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        Post returnPost = Post(
          post.fileName,
          post.displayFileName,
          post.lastModified,
          value: response.data,
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

  // /// delete file
  // /// @param bucketName type:String name of bucket
  // /// @param fileKey type:String upload filename
  // /// @return type:HttpRequest
  // HttpRequest deleteObject(String bucketName, String fileKey) {
  //   final url = "https://${bucketName}.${this.endpoint}/${fileKey}";
  //   final req = HttpRequest(url, 'DELETE', {}, {});
  //   this._auth.signRequest(req, bucketName, fileKey);
  //   return req;
  // }

  // /// start multipart upload
  // ///
  // ///
  // HttpRequest initMultipartUpload(String bucketName, String fileKey) {
  //   final url = "https://${bucketName}.${this.endpoint}/${fileKey}?uploads";
  //   final headers = {'content-type': "application/xml"};
  //   HttpRequest req = new HttpRequest(url, 'POST', {}, headers);
  //   this._auth.signRequest(req, bucketName, fileKey);
  //   return req;
  // }

  // HttpRequest uploadPart(String bucketName, String fileKey, String uploadId,
  //     int partNumber, List<int> data) {
  //   final url = "https://${bucketName}.${this.endpoint}/${fileKey}";
  //   final params = {"partNumber": '$partNumber', "uploadId": uploadId};
  //   HttpRequest req = new HttpRequest(url, 'PUT', params, {});
  //   req.fileData = data;
  //   this._auth.signRequest(req, bucketName, fileKey);
  //   return req;
  // }

  // HttpRequest completePartUpload(
  //     String bucketName, String fileKey, String uploadId, List<String> etags) {
  //   final url = "https://${bucketName}.${this.endpoint}/${fileKey}";
  //   final params = {"uploadId": uploadId};
  //   final builder = XmlBuilder();
  //   builder.element("CompleteMultipartUpload", nest: () {
  //     for (var i = 0; i < etags.length; i++) {
  //       builder.element("Part", nest: () {
  //         builder.element("PartNumber", nest: () {
  //           builder.text("${i + 1}");
  //         });
  //         builder.element("ETag", nest: () {
  //           builder.text("${etags[i]}");
  //         });
  //       });
  //     }
  //   });
  //   HttpRequest req = new HttpRequest(url, 'POST', params, {});
  //   final xml_request = builder.buildDocument().toXmlString();
  //   print("XML Request:$xml_request");
  //   req.fileData = utf8.encode(xml_request);
  //   this._auth.signRequest(req, bucketName, fileKey);
  //   return req;
  // }

  Options _getOptions(
    String httpMethod, {
    String file = '',
    String contentType = '',
  }) {
    var date = httpDateNow();
    print(date);
    var authorization = getAuthorization(
      this.accessKey,
      this.accessSecret,
      httpMethod,
      date,
      contentType: 'text/plain',
      path: file,
    );
    print(authorization);
    var headers = {
      'x-oss-date': date,
      'Authorization': authorization,
      'Connection': 'keep-alive',
      'Content-Type': 'text/plain',
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
        var displayFileName = fileName.substring(6);
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
