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
    var date = httpDateNow();
    print(date);
    var authorization =
        httpAuthorization(this.accessKey, this.accessSecret, 'GET', date);
    print(authorization);

    var options = Options(
      headers: {
        'x-oss-date': date,
        'Authorization': authorization,
      },
    );
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
  }

  // /// List Buckets
  // HttpRequest list_buckets(
  //     {prefix: '', marker: '', max_keys: 100, params: null}) {
  //   final listParam = {
  //     'prefix': prefix,
  //     'marker': marker,
  //     'max-keys': '${max_keys}'
  //   };
  //   if ((params ?? {}).isNotEmpty) {
  //     if (params.containsKey('tag-key')) {
  //       listParam['tag-key'] = params['tag-key'];
  //     }
  //     if (params.containsKey('tag-value')) {
  //       listParam['tag-value'] = params['tag-value'];
  //     }
  //   }
  //   final url = "http://${this.endpoint}";
  //   HttpRequest req = new HttpRequest(url, 'GET', listParam, {});
  //   this._auth.signRequest(req, '', '');
  //   return req;
  // }

  // /// upload file
  // /// @param fileData type:List<int> data of upload file
  // /// @param bucketName type:String name of bucket
  // /// @param fileKey type:String upload filename
  // /// @return type:HttpRequest
  // HttpRequest putObject(List<int> fileData, String bucketName, String fileKey) {
  //   final headers = {
  //     'content-md5': md5File(fileData),
  //     'content-type': contentTypeByFilename(fileKey)
  //   };
  //   final url = "https://${bucketName}.${this.endpoint}/${fileKey}";
  //   HttpRequest req = new HttpRequest(url, 'PUT', {}, headers);
  //   this._auth.signRequest(req, bucketName, fileKey);
  //   req.fileData = fileData;
  //   return req;
  // }

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
}
