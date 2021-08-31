import 'package:korat/models/platform.dart';

class PlatformGroup {
  String objectId = '';
  String name;
  PlatformModel? dataPlatform;
  PlatformModel? publishPlatform;

  PlatformGroup(
    this.name,
  );
}
