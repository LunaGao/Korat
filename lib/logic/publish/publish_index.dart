import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/templates/index_template.dart';
import 'package:korat/logic/publish/settings/blog_setting.dart';
import 'package:korat/logic/publish/settings/post_setting.dart';
import 'package:korat/logic/publish/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/publish_post_item.dart';

class PublishIndex {
  late PlatformClient platformClient;

  Future<void> init(PlatformClient platformClient) async {
    this.platformClient = platformClient;
  }

  Future<void> publishIndex(
    BlogSettingsLogic blogSettingsLogic,
    UserSettingsLogic userSettingsLogic,
    PostSettingsLogic postSettingsLogic,
    List<PublishPostItem> publishPostItems,
  ) async {
    // import 'package:flutter/services.dart' show rootBundle;
    // var indexTemplate =
    //     await rootBundle.loadString('assets/templates/index.html');
    var indexTemplate = IndexTemplate().indexTemplate;
    indexTemplate = await blogSettingsLogic.replaceTemplate(
      indexTemplate,
    );
    indexTemplate = await userSettingsLogic.replaceTemplate(
      indexTemplate,
    );

    var postsContent = '';
    if (publishPostItems.length >= 1) {
      var firstPostTemplate = await blogSettingsLogic.replaceIndexPostsTemplate(
        postSettingsLogic,
        publishPostItems[0],
      );
      postsContent = firstPostTemplate;
    }
    if (publishPostItems.length >= 2) {
      var secondPostTemplate =
          await blogSettingsLogic.replaceIndexPostsTemplate(
        postSettingsLogic,
        publishPostItems[1],
      );
      postsContent += secondPostTemplate;
    }

    indexTemplate = indexTemplate.replaceAll(
      "@postListKey@",
      postsContent,
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
