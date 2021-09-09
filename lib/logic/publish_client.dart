import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/template.dart';
import 'package:korat/logic/settings/blog_setting.dart';
import 'package:korat/logic/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/project.dart';
import 'package:markdown/markdown.dart';

class PublishClient {
  publish(ProjectModel projectModel) async {
    var platformClient = getPlatformClient(
      projectModel,
    );
    var postConfigResponse = await platformClient.getObject<String>(ObjModel(
      ConfigFilePath.postsConfigPath,
      null,
      ContentTypeConfig.json,
    ));
    List<Post> posts = [];
    if (postConfigResponse.isSuccess) {
      posts = PostConfig.fromJson(
        jsonDecode(
          postConfigResponse.message!,
        ),
      ).posts;
    } else {
      print("error: " + postConfigResponse.errorMessage);
      return;
    }
    await _publishIndex(platformClient, posts);
    for (Post post in posts) {
      ResponseModel<String> postResponseModel = await platformClient.getObject(
        ObjModel(
          post.fileFullNamePath,
          ' ',
          ContentTypeConfig.text,
        ),
      );
      if (postResponseModel.isSuccess) {
        var value = postResponseModel.message!.trim();
        _publishSubPage(platformClient, post, value);
      } else {
        print("error: " + postResponseModel.errorMessage);
        return;
      }
    }
  }

  _publishIndex(
    PlatformClient platformClient,
    List<Post> posts,
  ) async {
    // var indexTemplate =
    //     await rootBundle.loadString('assets/templates/index.html');
    var indexTemplate = IndexTemplate().indexTemplate;
    indexTemplate = await BlogSettingsLogic()
        .replaceIndexTemplate(indexTemplate, platformClient);
    indexTemplate = await UserSettingsLogic()
        .replaceIndexTemplate(indexTemplate, platformClient);
    await platformClient.putObject(
      ObjModel(
        'index.html',
        indexTemplate,
        ContentTypeConfig.html,
        isPublic: true,
      ),
    );
  }

  _publishSubPage(
    PlatformClient platformClient,
    Post post,
    String value,
  ) async {
    await platformClient.putObject(
      ObjModel(
        'posts/${post.fileName}.html',
        markdownToHtml(value),
        ContentTypeConfig.html,
        isPublic: true,
      ),
    );
  }
}
