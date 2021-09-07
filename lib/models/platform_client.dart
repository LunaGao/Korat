import 'dart:typed_data';

import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/aliyun_oss/aliyun_oss_client.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/platform_config.dart';
import 'package:korat/models/platform.dart';

abstract class PlatformClient {
  Future<ResponseModel<String>> putObject(ObjModel objModel);
  Future<ResponseModel<T>> getObject<T>(ObjModel objModel);
  Future<ResponseModel<String>> deleteObject(ObjModel objModel);
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
