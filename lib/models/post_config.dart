import 'package:korat/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_config.g.dart';

@JsonSerializable()
class PostConfig {
  List<Post> posts;

  PostConfig(
    this.posts,
  );

  factory PostConfig.fromJson(Map<String, dynamic> json) =>
      _$PostConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PostConfigToJson(this);
}
