import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';

class UserSettingsLogic {
  Future<String> replaceIndexTemplate(
    String indexTemplate,
    PlatformClient platformClient,
  ) async {
    var returnValue = indexTemplate;
    var userConfigs = await BaseSettingsHelper().getConfigSettings(
      platformClient,
      ConfigFilePath.userSettingPath,
      SettingsConfig.userConfigKeys,
    );
    for (String key in SettingsConfig.userConfigKeys) {
      returnValue =
          BaseSettingsHelper().replaceString(key, userConfigs, returnValue);
    }
    return returnValue;
  }
}
