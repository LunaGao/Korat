import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';

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

  Future<String> replaceIndexTemplate(
    String indexTemplate,
  ) async {
    var returnValue = indexTemplate;
    for (String key in SettingsConfig.blogConfigKeys) {
      returnValue = BaseSettingsHelper().replaceString(
        key,
        this.configs,
        returnValue,
      );
    }
    return returnValue;
  }

  Future<String> replaceIndexPostsTemplate(
    String postContentTemplate,
    Map<String, String> postConfig,
  ) async {
    var returnValue = postContentTemplate;
    for (String key in SettingsConfig.postConfigKeys) {
      returnValue = BaseSettingsHelper().replaceString(
        key,
        postConfig,
        returnValue,
      );
    }

    return returnValue;
  }
}
