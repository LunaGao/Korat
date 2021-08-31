import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';

class PlatformApi {
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

  Future<ResponseModel> postAliyunOSSPlatform(
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
}
