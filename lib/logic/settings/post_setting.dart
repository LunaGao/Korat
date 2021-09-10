import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';

class PostSettingsLogic {
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

  Future<Map<String, String>> getPostSettings(
    PlatformClient platformClient,
    Post post,
  ) async {
    var returnValue = Map<String, String>();
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
    returnValue.putIfAbsent(SettingsConfig.postContentKey, () => postContent);
    returnValue.putIfAbsent(
        SettingsConfig.postTitleKey, () => post.displayFileName);
    returnValue.putIfAbsent(SettingsConfig.postContentLongDesKey,
        () => getLongDesContent(postContent));
    returnValue.putIfAbsent(SettingsConfig.postContentShortDesKey,
        () => getShortDesContent(postContent));
    returnValue.putIfAbsent(
        SettingsConfig.postLinkKey, () => 'posts/${post.fileName}.html');
    returnValue.putIfAbsent(
        SettingsConfig.postTimeKey, () => post.lastModified);
    return returnValue;
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
