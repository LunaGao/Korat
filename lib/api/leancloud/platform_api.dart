import 'package:korat/api/base_model/base_model.dart';
import 'package:korat/api/leancloud/base_api.dart';

class PlatformApi {
  Future<ApiResponseModel> getMyPlatforms(String userObjectId) async {
    return BaseApi().get(
      '/classes/Platform',
      {'where': '{"owner": "' + userObjectId + '"}'},
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
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }
}
