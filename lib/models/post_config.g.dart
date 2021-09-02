// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostConfig _$PostConfigFromJson(Map<String, dynamic> json) {
  return PostConfig(
    (json['posts'] as List<dynamic>)
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PostConfigToJson(PostConfig instance) =>
    <String, dynamic>{
      'posts': instance.posts,
    };
