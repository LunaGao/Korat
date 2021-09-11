import 'package:flutter/services.dart' show rootBundle;
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/templates/index_template.dart';
import 'package:korat/logic/publish_post.dart';
import 'package:korat/logic/settings/blog_setting.dart';
import 'package:korat/logic/settings/post_setting.dart';
import 'package:korat/logic/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/project.dart';

class PublishClient {
  BlogSettingsLogic blogSettingsLogic = BlogSettingsLogic();
  PublishPost publishPost = PublishPost();

  publish(ProjectModel projectModel) async {
    var platformClient = getPlatformClient(
      projectModel,
    );
    await blogSettingsLogic.init(platformClient);
    await publishPost.init(platformClient);

    Map<String, String> firstPost = {};
    Map<String, String> secondPost = {};
    int index = 0;
    for (Post post in publishPost.posts) {
      var postConfigs = await PostSettingsLogic().getPostSettings(
        platformClient,
        post,
      );
      if (index == 0) {
        firstPost = postConfigs;
      } else if (index == 1) {
        secondPost = postConfigs;
      }
      await publishPost.publishSubPage(
        post,
        postConfigs[SettingsConfig.postContentKey]!,
      );
      index++;
    }
    await _publishIndex(
      platformClient,
      firstPost,
      secondPost,
    );
  }

  _publishIndex(
    PlatformClient platformClient,
    Map<String, String> firstPost,
    Map<String, String> secondPost,
  ) async {
    // var indexTemplate =
    //     await rootBundle.loadString('assets/templates/index.html');
    var indexTemplate = IndexTemplate().indexTemplate;
    indexTemplate = await blogSettingsLogic.replaceIndexTemplate(
      indexTemplate,
    );
    indexTemplate = await UserSettingsLogic()
        .replaceIndexTemplate(indexTemplate, platformClient);
    var postTemplate = IndexTemplate().indexItemTemplate;
    var firstPostTemplate = await blogSettingsLogic.replaceIndexPostsTemplate(
      postTemplate,
      firstPost,
    );
    var secondPostTemplate = await blogSettingsLogic.replaceIndexPostsTemplate(
      postTemplate,
      secondPost,
    );
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
}
