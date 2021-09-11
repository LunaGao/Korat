import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/templates/post_template.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/logic/settings/blog_setting.dart';
import 'package:korat/logic/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/publish_post_item.dart';
import 'package:markdown/markdown.dart';

class PublishPost {
  late PlatformClient platformClient;
  late PostConfig postConfig;

  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
    var postConfigResponse = await this.platformClient.getObject<String>(
          ObjModel(
            ConfigFilePath.postsConfigPath,
            null,
            ContentTypeConfig.json,
          ),
        );
    if (postConfigResponse.isSuccess) {
      this.postConfig = PostConfig.fromJson(
        jsonDecode(
          postConfigResponse.message!,
        ),
      )..posts.sort(
          (a, b) => (int.parse(b.fileName).compareTo(int.parse(a.fileName))),
        );
    } else {
      print("error: " + postConfigResponse.errorMessage);
    }
  }

  Post? getPost(int index) {
    if (postConfig.posts.length < index + 1) {
      return postConfig.posts[index];
    }
    return null;
  }

  Future<void> publishSubPage(
    BlogSettingsLogic blogSettingsLogic,
    UserSettingsLogic userSettingsLogic,
    PublishPostItem publishPostItem,
  ) async {
    var templateString = PostTemplate().postTemplate;
    templateString = await blogSettingsLogic.replaceTemplate(
      templateString,
    );
    templateString = await userSettingsLogic.replaceTemplate(
      templateString,
    );
    templateString = BaseSettingsHelper().replaceString(
      SettingsConfig.contentKey,
      markdownToHtml(publishPostItem.content),
      templateString,
    );
    templateString = BaseSettingsHelper().replaceString(
      SettingsConfig.postTitleKey,
      publishPostItem.post.displayFileName,
      templateString,
    );
    templateString = BaseSettingsHelper().replaceString(
      SettingsConfig.postTimeKey,
      publishPostItem.post.lastModified,
      templateString,
    );
    await platformClient.putObject(
      ObjModel(
        publishPostItem.postLink,
        templateString,
        ContentTypeConfig.html,
        isPublic: true,
      ),
    );
  }
}
