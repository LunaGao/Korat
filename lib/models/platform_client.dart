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

PlatformClient getPlatformClient(PlatformModel platformModel) {
  if (platformModel.platform == PlatformConfig.aliyunOSS) {
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

String getDisplayPlatformNameFromString(String? platformName) {
  if (platformName == PlatformConfig.aliyunOSS) {
    return "aliyun oss";
  } else {
    return "未设置";
  }
}
