import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/templates/index_template.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/logic/settings/post_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/publish_post_item.dart';

class BlogSettingsLogic {
  late PlatformClient platformClient;
  Map<String, String> configs = {};

  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
    this.configs = await BaseSettingsHelper().getConfigSettings(
      platformClient,
      ConfigFilePath.blogSettingPath,
      SettingsConfig.blogConfigKeys,
    );
  }

  Future<String> replaceTemplate(
    String templateString,
  ) async {
    var returnValue = templateString;
    for (String key in SettingsConfig.blogConfigKeys) {
      returnValue = BaseSettingsHelper().replaceStringWithConfigs(
        key,
        this.configs,
        returnValue,
      );
    }
    return returnValue;
  }

  Future<String> replaceIndexPostsTemplate(
    PostSettingsLogic postSettingsLogic,
    PublishPostItem postConfig,
  ) async {
    var returnValue = IndexTemplate().indexItemTemplate;
    returnValue = BaseSettingsHelper().replaceString(
      SettingsConfig.postTitleKey,
      postConfig.post.displayFileName,
      returnValue,
    );
    returnValue = BaseSettingsHelper().replaceString(
      SettingsConfig.postContentLongDesKey,
      postSettingsLogic.getLongDesContent(postConfig.content),
      returnValue,
    );
    returnValue = BaseSettingsHelper().replaceString(
      SettingsConfig.postLinkKey,
      postConfig.postLink,
      returnValue,
    );
    return returnValue;
  }
}
