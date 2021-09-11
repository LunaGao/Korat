import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/models/platform_client.dart';

class UserSettingsLogic {
  late PlatformClient platformClient;
  Map<String, String> configs = {};

  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
    this.configs = await BaseSettingsHelper().getConfigSettings(
      this.platformClient,
      ConfigFilePath.userSettingPath,
      SettingsConfig.userConfigKeys,
    );
  }

  Future<String> replaceTemplate(
    String templateString,
  ) async {
    var returnValue = templateString;
    for (String key in SettingsConfig.userConfigKeys) {
      returnValue = BaseSettingsHelper().replaceStringWithConfigs(
        key,
        this.configs,
        returnValue,
      );
    }
    return returnValue;
  }
}
