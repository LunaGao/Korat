import 'dart:convert';

import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/config/templates/post_template.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:markdown/markdown.dart';

class PublishPost {
  late PlatformClient platformClient;
  List<Post> posts = [];

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
      this.posts = PostConfig.fromJson(
        jsonDecode(
          postConfigResponse.message!,
        ),
      ).posts;
      this.posts.sort(
            (a, b) => (int.parse(b.fileName).compareTo(int.parse(a.fileName))),
          );
    } else {
      print("error: " + postConfigResponse.errorMessage);
    }
  }

  Future<void> publishSubPage(
    Post post,
    String value,
  ) async {
    var postTemplate = PostTemplate().postTemplate;
    postTemplate = postTemplate.replaceAll(
      "@content@",
      markdownToHtml(value),
    );
    await platformClient.putObject(
      ObjModel(
        'posts/${post.fileName}.html',
        postTemplate,
        ContentTypeConfig.html,
        isPublic: true,
      ),
    );
  }
}
