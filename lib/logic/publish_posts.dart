import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/setting_config.dart';
import 'package:korat/config/templates/posts_template.dart';
import 'package:korat/logic/settings/base_setting_helper.dart';
import 'package:korat/logic/settings/blog_setting.dart';
import 'package:korat/logic/settings/post_setting.dart';
import 'package:korat/logic/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/publish_post_item.dart';

class PublishPosts {
  late PlatformClient platformClient;

  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
  }

  Future<void> publishPosts(
    BlogSettingsLogic blogSettingsLogic,
    UserSettingsLogic userSettingsLogic,
    PostSettingsLogic postSettingsLogic,
    List<PublishPostItem> publishPostItems,
  ) async {
    // import 'package:flutter/services.dart' show rootBundle;
    // var indexTemplate =
    //     await rootBundle.loadString('assets/templates/index.html');
    var template = PostsTemplate().postsTemplate;
    template = await blogSettingsLogic.replaceTemplate(
      template,
    );
    template = await userSettingsLogic.replaceTemplate(
      template,
    );
    String postListContent = '';
    for (PublishPostItem publishPostItem in publishPostItems) {
      var postTemplate = PostsTemplate().postItemTemplate;
      postTemplate = BaseSettingsHelper().replaceString(
        SettingsConfig.postLinkKey,
        publishPostItem.postLink,
        postTemplate,
      );
      postTemplate = BaseSettingsHelper().replaceString(
        SettingsConfig.postTitleKey,
        publishPostItem.post.displayFileName,
        postTemplate,
      );
      postTemplate = BaseSettingsHelper().replaceString(
        SettingsConfig.postContentShortDesKey,
        postSettingsLogic.getShortDesContent(publishPostItem.content),
        postTemplate,
      );
      postListContent += postTemplate;
    }
    template = template.replaceAll(
      "@content@",
      postListContent,
    );
    await platformClient.putObject(
      ObjModel(
        'posts.html',
        template,
        ContentTypeConfig.html,
        isPublic: true,
      ),
    );
  }
}
