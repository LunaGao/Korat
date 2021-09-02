import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String fileFullNamePath;
  String displayFileName;
  String lastModified;
  List<String> tags;
  String category;

  Post(
    this.fileFullNamePath,
    this.displayFileName,
    this.lastModified,
    this.tags,
    this.category,
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
