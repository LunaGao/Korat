class Post {
  String fileName;
  String displayFileName;
  String lastModified;
  String value;

  Post(
    this.fileName,
    this.displayFileName,
    this.lastModified, {
    this.value = '',
  });
}
