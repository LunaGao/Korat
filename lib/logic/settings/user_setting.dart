import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/models/platform_client.dart';

class UserSettingsLogic {
  replaceIndexTemplate(
    String indexTemplate,
    PlatformClient platformClient,
  ) async {
    var returnValue = indexTemplate;
    var blogConfigs = await getBlogSettings(platformClient);
    returnValue =
        _replaceString(SettingsConfig.userNameKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.userDetailKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.userAvatarKey, blogConfigs, returnValue);
    return returnValue;
  }

  getBlogSettings(
    PlatformClient platformClient,
  ) async {
    var returnValue = Map<String, String>();
    var userName = '';
    var userDetail = '';
    var userAvatar = '';
    var userConfigResponseModel = await platformClient.getObject<String>(
      ObjModel(
        ConfigFilePath.userSettingPath,
        null,
        ContentTypeConfig.json,
      ),
    );
    if (userConfigResponseModel.isSuccess) {
      var userSettings = jsonDecode(userConfigResponseModel.message!);
      userName = _getValueItem(SettingsConfig.userNameKey, userSettings);
      userDetail = _getValueItem(SettingsConfig.userDetailKey, userSettings);
      userAvatar = _getValueItem(SettingsConfig.userAvatarKey, userSettings);
    }
    returnValue.putIfAbsent(SettingsConfig.userNameKey, () => userName);
    returnValue.putIfAbsent(SettingsConfig.userDetailKey, () => userDetail);
    returnValue.putIfAbsent(SettingsConfig.userAvatarKey, () => userAvatar);
    return returnValue;
  }

  _getValueItem(
    String key,
    Map<String, dynamic> items,
  ) {
    if (items.containsKey(key)) {
      var item = items[key];
      return item["value"];
    } else {
      return '';
    }
  }

  String _replaceString(
    String key,
    Map<String, String> configs,
    String source,
  ) {
    String oldString = "@$key@";
    String newString = '';
    if (configs.containsKey(key)) {
      newString = configs[key]!;
    }
    return source.replaceAll(oldString, newString);
  }
}
