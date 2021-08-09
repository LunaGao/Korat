import 'package:korat/api/base_model/base_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/config/platform_config.dart';

class PlatformApi {
  Future<ApiResponseModel> getMyPlatforms(String currentUserId) async {
    return BaseApi().getWithAuth(
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
  }

  Future<ApiResponseModel> postAliyunOSSPlatform(
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
}
