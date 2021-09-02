import 'package:korat/api/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/post_item.dart';

abstract class PlatformClient {
  setPlatformModel(PlatformModel platformModel);
  PlatformModel getPlatformModel();
  putObject(String fileNamePath, String value);
  Future<ResponseModel<PostConfig>> getPostConfig();
  putPostConfig(String value);
  Future<ResponseModel<PostItem>> getPostObject(Post postItem);
  deleteObject(String fileFullNamePath);
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
