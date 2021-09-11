import 'package:korat/models/platform_client.dart';

class PublishIndex {
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
}
