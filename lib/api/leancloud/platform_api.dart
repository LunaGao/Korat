import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';

class PlatformApi {
  Future<ResponseModel<PlatformModel>> getPlatformById(String objectId) async {
    var response =
        await BaseApi().getWithAuth('/classes/Platform/$objectId', {});

    return _getPlatform(response);
  }

  Future<ResponseModel> getMyPlatforms(String currentUserId) async {
    var response = await BaseApi().getWithAuth(
      '/classes/Platform',
      {
        'where': {
          'owner': {
            "__type": "Pointer",
            "className": "_User",
            "objectId": currentUserId,
          },
        }
      },
    );

    return _getListForPlatform(response);
  }

  Future<ResponseModel> updateAliyunOSSPlatform(
    String objectId,
    String endpoint,
    String bucket,
    String accessKeyId,
    String accessKeySecret,
  ) async {
    return BaseApi().putWithAuth(
      '/classes/Platform/$objectId',
      {
        'endPoint': endpoint,
        'bucket': bucket,
        'keyId': accessKeyId,
        'keySecret': accessKeySecret,
        'platform': PlatformConfig.aliyunOSS,
      },
    );
  }

  Future<ResponseModel> createAliyunOSSPlatform(
    String endpoint,
    String bucket,
    String accessKeyId,
    String accessKeySecret,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/Platform',
      {
        'endPoint': endpoint,
        'bucket': bucket,
        'keyId': accessKeyId,
        'keySecret': accessKeySecret,
        'platform': PlatformConfig.aliyunOSS,
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  ResponseModel<List<PlatformModel>> _getListForPlatform(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<List<PlatformModel>> returnValue =
        ResponseModel<List<PlatformModel>>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    List<PlatformModel> data = [];
    for (Map item in response.message["results"]) {
      var platform = PlatformModel();
      platform.objectId = item['objectId'];
      platform.platform = item['platform'];
      platform.keySecret = item['keySecret'];
      platform.keyId = item['keyId'];
      platform.endPoint = item['endPoint'];
      platform.bucket = item['bucket'];
      data.add(platform);
    }
    returnValue.message = data;
    return returnValue;
  }

  ResponseModel<PlatformModel> _getPlatform(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<PlatformModel> returnValue = ResponseModel<PlatformModel>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    var item = response.message;
    var platform = PlatformModel();
    platform.objectId = item['objectId'];
    platform.platform = item['platform'];
    platform.keySecret = item['keySecret'];
    platform.keyId = item['keyId'];
    platform.endPoint = item['endPoint'];
    platform.bucket = item['bucket'];
    returnValue.message = platform;
    return returnValue;
  }
}
