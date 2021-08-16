import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/post.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';

abstract class PlatformClient {
  setPlatformModel(PlatformModel platformModel);
  PlatformModel getPlatformModel();
  listObjects();
  putObject(String fileNamePath, String value);
  getObject(Post post);
  deleteObject(Post post);
}

PlatformClient getPlatformClient(dynamic platformJson) {
  PlatformModel platformModel = PlatformModel();
  platformModel.platform = platformJson['platform'];
  platformModel.endPoint = platformJson['endPoint'];
  platformModel.keyId = platformJson['keyId'];
  platformModel.keySecret = platformJson['keySecret'];
  platformModel.bucket = platformJson['bucket'];
  if (platformJson['platform'] == PlatformConfig.aliyunOSS) {
    return AliyunOSSClient(
      platformModel,
    );
  } else {
    //TODO: 这里需要搞一个空的返回值
    return AliyunOSSClient(
      platformModel,
    );
  }
}
