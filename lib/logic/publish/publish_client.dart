import 'package:korat/logic/publish/publish_index.dart';
import 'package:korat/logic/publish/publish_post.dart';
import 'package:korat/logic/publish/publish_posts.dart';
import 'package:korat/logic/publish/settings/blog_setting.dart';
import 'package:korat/logic/publish/settings/post_setting.dart';
import 'package:korat/logic/publish/settings/user_setting.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/project.dart';
import 'package:korat/models/publish_post_item.dart';

class PublishClient {
  BlogSettingsLogic blogSettingsLogic = BlogSettingsLogic();
  UserSettingsLogic userSettingsLogic = UserSettingsLogic();
  PostSettingsLogic postSettingsLogic = PostSettingsLogic();
  PublishPost publishPost = PublishPost();
  PublishIndex publishIndex = PublishIndex();
  PublishPosts publishPosts = PublishPosts();

  publish(ProjectModel projectModel) async {
    var platformClient = getPlatformClient(
      projectModel,
    );
    await blogSettingsLogic.init(platformClient);
    await userSettingsLogic.init(platformClient);
    await postSettingsLogic.init(platformClient);
    await publishIndex.init(platformClient);
    await publishPost.init(platformClient);
    await publishPosts.init(platformClient);
    List<PublishPostItem> postItems = [];
    for (Post post in publishPost.postConfig.posts) {
      var publishPostItem = await postSettingsLogic.getPublishPostItem(
        post,
      );
      postItems.add(publishPostItem);
      await publishPost.publishSubPage(
        blogSettingsLogic,
        userSettingsLogic,
        publishPostItem,
      );
    }
    await publishPosts.publishPosts(
      blogSettingsLogic,
      userSettingsLogic,
      postSettingsLogic,
      postItems,
    );
    await publishIndex.publishIndex(
      blogSettingsLogic,
      userSettingsLogic,
      postSettingsLogic,
      postItems,
    );
  }
}
