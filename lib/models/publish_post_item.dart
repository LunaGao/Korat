import 'package:korat/models/post.dart';

class PublishPostItem {
  Post post;
  String postLink;
  String content;

  PublishPostItem(
    this.post,
  )   : this.postLink = 'posts/${post.fileName}.html',
        this.content = '';
}
