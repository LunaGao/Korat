class ObjModel {
  String fileFullNamePath;
  dynamic value;
  String contentType;
  bool isPublic;

  ObjModel(
    this.fileFullNamePath,
    this.value,
    this.contentType, {
    this.isPublic = false,
  });
}
