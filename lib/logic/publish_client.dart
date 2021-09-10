import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/template.dart';
import 'package:korat/logic/settings/blog_setting.dart';
import 'package:korat/logic/settings/post_setting.dart';
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
    posts.sort(
        (a, b) => (int.parse(b.fileName).compareTo(int.parse(a.fileName))));
    Map<String, String> firstPost = {};
    Map<String, String> secondPost = {};
    int index = 0;
    for (Post post in posts) {
      var postConfigs = await PostSettingsLogic().getPostSettings(
        platformClient,
        post,
      );
      if (index == 0) {
        firstPost = postConfigs;
      } else if (index == 1) {
        secondPost = postConfigs;
      }
      _publishSubPage(
        platformClient,
        post,
        postConfigs[SettingsConfig.postContentKey]!,
      );
      index++;
    }
    await _publishIndex(
      platformClient,
      posts,
      firstPost,
      secondPost,
    );
  }

  _publishIndex(
    PlatformClient platformClient,
    List<Post> posts,
    Map<String, String> firstPost,
    Map<String, String> secondPost,
  ) async {
    // var indexTemplate =
    //     await rootBundle.loadString('assets/templates/index.html');
    var indexTemplate = IndexTemplate().indexTemplate;
    indexTemplate = await BlogSettingsLogic()
        .replaceIndexTemplate(indexTemplate, platformClient);
    indexTemplate = await UserSettingsLogic()
        .replaceIndexTemplate(indexTemplate, platformClient);
    var postTemplate = IndexTemplate().indexItemTemplate;
    var firstPostTemplate = await BlogSettingsLogic()
        .replaceIndexPostsTemplate(postTemplate, firstPost);
    var secondPostTemplate = await BlogSettingsLogic()
        .replaceIndexPostsTemplate(postTemplate, secondPost);
    indexTemplate = indexTemplate.replaceAll(
      "@postListKey@",
      firstPostTemplate + secondPostTemplate,
    );
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
