// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['fileFullNamePath'] as String,
    json['displayFileName'] as String,
    json['lastModified'] as String,
    (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    json['category'] as String,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'fileFullNamePath': instance.fileFullNamePath,
      'displayFileName': instance.displayFileName,
      'lastModified': instance.lastModified,
      'tags': instance.tags,
      'category': instance.category,
    };
