import 'package:dio/dio.dart';
import 'package:korat/api/aliyun_oss/utils.dart';
import 'package:korat/api/base_model/base_model.dart';

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

  Future<ApiResponseModel> listObjects() async {
    var options = _getOptions('GET');
    try {
      var response = await Dio().get(
        "http://$bucket.$endpoint/?list-type=2&prefix=korat/",
        options: options,
      );
      print(response);
      if (200 <= response.statusCode! && response.statusCode! < 300) {
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
    }

//     <?xml version="1.0" encoding="UTF-8"?>
// <ListBucketResult>
//   <Name>korat-data</Name>
//   <Prefix>korat/</Prefix>
//   <MaxKeys>100</MaxKeys>
//   <Delimiter></Delimiter>
//   <IsTruncated>false</IsTruncated>
//   <KeyCount>0</KeyCount>
// </ListBucketResult>

// <?xml version="1.0" encoding="UTF-8"?>
// <ListBucketResult>
//   <Name>korat-data</Name>
//   <Prefix>korat/</Prefix>
//   <MaxKeys>100</MaxKeys>
//   <Delimiter></Delimiter>
//   <IsTruncated>false</IsTruncated>
//   <Contents>
//     <Key>korat/hello</Key>
//     <LastModified>2021-08-11T15:35:08.000Z</LastModified>
//     <ETag>"5D41402ABC4B2A76B9719D911017C592"</ETag>
//     <Type>Normal</Type>
//     <Size>5</Size>
//     <StorageClass>Standard</StorageClass>
//   </Contents>
//   <KeyCount>1</KeyCount>
// </ListBucketResult>
  }

  Future<ApiResponseModel> putObject() async {
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
        return ApiResponseModel(isSuccess: true, message: response.data);
      } else {
        return ApiResponseModel(isSuccess: false, errorMessage: "");
      }
    } on DioError catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.response!.data);
    } catch (e) {
      return ApiResponseModel(isSuccess: false, errorMessage: e.toString());
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
}
