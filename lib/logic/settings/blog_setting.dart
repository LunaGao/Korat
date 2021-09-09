import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/models/platform_client.dart';

class BlogSettingsLogic {
  replaceIndexTemplate(
    String indexTemplate,
    PlatformClient platformClient,
  ) async {
    var returnValue = indexTemplate;
    var blogConfigs = await getBlogSettings(platformClient);
    returnValue = _replaceString(
        SettingsConfig.blogCopyrightKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.blogDetailKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.blogDomainKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.blogLogoKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.blogRecordKey, blogConfigs, returnValue);
    returnValue =
        _replaceString(SettingsConfig.blogTitleKey, blogConfigs, returnValue);
    return returnValue;
  }

  getBlogSettings(
    PlatformClient platformClient,
  ) async {
    var returnValue = Map<String, String>();
    var blogTitle = '';
    var blogDomain = '';
    var blogDetail = '';
    var blogRecord = '';
    var blogCopyright = '';
    var blogLogo = '';
    var postConfigResponseModel = await platformClient.getObject<String>(
      ObjModel(
        ConfigFilePath.blogSettingPath,
        null,
        ContentTypeConfig.json,
      ),
    );
    if (postConfigResponseModel.isSuccess) {
      var postSettings = jsonDecode(postConfigResponseModel.message!);
      blogTitle = _getValueItem(SettingsConfig.blogTitleKey, postSettings);
      blogDomain = _getValueItem(SettingsConfig.blogDomainKey, postSettings);
      blogDetail = _getValueItem(SettingsConfig.blogDetailKey, postSettings);
      blogRecord = _getValueItem(SettingsConfig.blogRecordKey, postSettings);
      blogCopyright =
          _getValueItem(SettingsConfig.blogCopyrightKey, postSettings);
      blogLogo = _getValueItem(SettingsConfig.blogLogoKey, postSettings);
    }
    returnValue.putIfAbsent(SettingsConfig.blogTitleKey, () => blogTitle);
    returnValue.putIfAbsent(SettingsConfig.blogDomainKey, () => blogDomain);
    returnValue.putIfAbsent(SettingsConfig.blogDetailKey, () => blogDetail);
    returnValue.putIfAbsent(SettingsConfig.blogRecordKey, () => blogRecord);
    returnValue.putIfAbsent(
        SettingsConfig.blogCopyrightKey, () => blogCopyright);
    returnValue.putIfAbsent(SettingsConfig.blogLogoKey, () => blogLogo);
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
