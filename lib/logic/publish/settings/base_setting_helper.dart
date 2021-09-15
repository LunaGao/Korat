import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/models/platform_client.dart';

class BaseSettingsHelper {
  Future<Map<String, String>> getConfigSettings(
    PlatformClient platformClient,
    String requirePath,
    List<String> keys,
  ) async {
    var returnValue = Map<String, String>();
    var responseModel = await platformClient.getObject<String>(
      ObjModel(
        requirePath,
        null,
        ContentTypeConfig.json,
      ),
    );
    if (responseModel.isSuccess) {
      var postSettings = jsonDecode(responseModel.message!);
      for (String key in keys) {
        returnValue.putIfAbsent(
            key, () => BaseSettingsHelper().getValueItem(key, postSettings));
      }
    } else {
      for (String key in keys) {
        returnValue.putIfAbsent(key, () => "");
      }
    }
    return returnValue;
  }

  String getValueItem(
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

  String replaceStringWithConfigs(
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

  String replaceString(
    String key,
    String value,
    String source,
  ) {
    String oldString = "@$key@";
    return source.replaceAll(oldString, value);
  }
}
