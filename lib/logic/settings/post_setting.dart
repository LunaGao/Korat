import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/publish_post_item.dart';

class PostSettingsLogic {
  late PlatformClient platformClient;
  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
  }
  // replaceIndexTemplate(
  //   String indexTemplate,
  //   PlatformClient platformClient,
  // ) async {
  //   var returnValue = indexTemplate;
  //   var blogConfigs = await getBlogSettings(platformClient);
  //   returnValue = BaseSettingsHelper().replaceString(
  //       SettingsConfig.blogCopyrightKey, blogConfigs, returnValue);
  //   returnValue = BaseSettingsHelper()
  //       .replaceString(SettingsConfig.blogDetailKey, blogConfigs, returnValue);
  //   returnValue = BaseSettingsHelper()
  //       .replaceString(SettingsConfig.blogDomainKey, blogConfigs, returnValue);
  //   returnValue = BaseSettingsHelper()
  //       .replaceString(SettingsConfig.blogLogoKey, blogConfigs, returnValue);
  //   returnValue = BaseSettingsHelper()
  //       .replaceString(SettingsConfig.blogRecordKey, blogConfigs, returnValue);
  //   returnValue = BaseSettingsHelper()
  //       .replaceString(SettingsConfig.blogTitleKey, blogConfigs, returnValue);
  //   return returnValue;
  // }

  Future<PublishPostItem> getPublishPostItem(
    Post post,
  ) async {
    var publishPostItem = PublishPostItem(post);
    var postResponseModel = await platformClient.getObject<String>(
      ObjModel(
        post.fileFullNamePath,
        null,
        ContentTypeConfig.text,
      ),
    );
    var postContent = '';
    if (postResponseModel.isSuccess) {
      postContent = postResponseModel.message!.trim();
    }
    publishPostItem.content = postContent;
    return publishPostItem;
  }

  String getShortDesContent(String source) {
    return getDesContent(100, source);
  }

  String getLongDesContent(String source) {
    return getDesContent(300, source);
  }

  String getDesContent(int maxLenth, String source) {
    if (source.length <= maxLenth) {
      return source;
    } else {
      int middleIndex = maxLenth;
      middleIndex = maxLenth ~/ 2;
      String startString = source.substring(0, middleIndex - 2);
      String endString =
          source.substring(source.length - middleIndex + 1, source.length - 1);
      return "$startString...$endString";
    }
  }
}
