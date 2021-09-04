import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/models/platform_client.dart';
import 'package:korat/models/platform_group.dart';
import 'package:korat/models/post.dart';
import 'package:korat/models/post_item.dart';

class PublishClient {
  publish(PlatformGroup platformGroup) async {
    if (platformGroup.dataPlatform == null) {
      return;
    }
    if (platformGroup.publishPlatform == null) {
      return;
    }
    var dataPlatformClient = getPlatformClient(
      platformGroup.dataPlatform!,
    );
    var publishPlatformClient = getPlatformClient(
      platformGroup.publishPlatform!,
    );
    var result = await dataPlatformClient.getPostConfig();
    List<Post> posts = [];
    if (result.isSuccess) {
      posts = result.message!.posts;
    } else {
      print("error: " + result.errorMessage);
      return;
    }
    for (Post post in posts) {
      ResponseModel<PostItem> postResponseModel =
          await dataPlatformClient.getPostObject(post);
      if (postResponseModel.isSuccess) {
        ResponseModel<PostItem> postItemResponseModel =
            await dataPlatformClient.getPostObject(post);
        if (postItemResponseModel.isSuccess) {
          await publishPlatformClient.putObject(
            'post/${post.fileName}.html',
            postItemResponseModel.message!.value,
            contentType: "text/html;charset=utf-8",
          );
        } else {
          print("error: " + result.errorMessage);
          return;
        }
      } else {
        print("error: " + result.errorMessage);
        return;
      }
    }
  }
}
