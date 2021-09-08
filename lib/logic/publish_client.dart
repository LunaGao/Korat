import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/platforms/model/object_model.dart';
import 'package:korat/config/config_file_path.dart';
import 'package:korat/config/content_type_config.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_config.dart';
import 'package:korat/models/project.dart';
import 'package:markdown/markdown.dart';
import 'package:korat/models/post_item.dart';

class PublishClient {
  publish(ProjectModel projectModel) async {
    // var dataPlatformClient = getPlatformClient(
    //   platformGroup.dataPlatform!,
    // );
    // var publishPlatformClient = getPlatformClient(
    //   platformGroup.publishPlatform!,
    // );
    // var result = await dataPlatformClient.getObject<PostConfig>(ObjModel(
    //   ConfigFilePath.postsConfigPath,
    //   null,
    //   ContentTypeConfig.json,
    // ));
    // List<Post> posts = [];
    // if (result.isSuccess) {
    //   posts = result.message!.posts;
    // } else {
    //   print("error: " + result.errorMessage);
    //   return;
    // }
    // for (Post post in posts) {
    // ResponseModel<PostItem> postResponseModel =
    //     await dataPlatformClient.getPostObject(post);
    // if (postResponseModel.isSuccess) {
    //   ResponseModel<PostItem> postItemResponseModel =
    //       await dataPlatformClient.getPostObject(post);
    //   if (postItemResponseModel.isSuccess) {
    //     var value = postItemResponseModel.message!.value.trim();
    //     await publishPlatformClient.putObject(
    //       ObjModel(
    //         'data/${post.fileName}.html',
    //         markdownToHtml(value),
    //         ContentTypeConfig.html,
    //       ),
    //     );
    //   } else {
    //     print("error: " + result.errorMessage);
    //     return;
    //   }
    // } else {
    //   print("error: " + result.errorMessage);
    //   return;
    // }
    // }
  }
}
