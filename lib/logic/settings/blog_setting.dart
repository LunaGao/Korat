import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';

class BlogSettingsLogic {
  Future<String> replaceIndexTemplate(
    String indexTemplate,
    PlatformClient platformClient,
  ) async {
    var returnValue = indexTemplate;
    var blogConfigs = await BaseSettingsHelper().getConfigSettings(
      platformClient,
      ConfigFilePath.blogSettingPath,
      SettingsConfig.blogConfigKeys,
    );
    for (String key in SettingsConfig.blogConfigKeys) {
      returnValue =
          BaseSettingsHelper().replaceString(key, blogConfigs, returnValue);
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
