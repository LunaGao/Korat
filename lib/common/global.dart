import 'package:korat/api/base_model/user.dart';
import 'package:korat/api/leancloud/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences? _prefs;
  static User? _user;
  static User? get user => _user;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();

    var meResponse = await UserApi().me();
    if (!meResponse.isSuccess) {
      await _prefs!.remove('sessionToken');
    } else {
      _user = meResponse.message!;
    }
  }

  static Future signin(String sessionToken) async {
    await _prefs!.setString('sessionToken', sessionToken);
    var meResponse = await UserApi().me();
    if (!meResponse.isSuccess) {
      await _prefs!.remove('sessionToken');
    } else {
      _user = meResponse.message!;
    }
  }

  static Future logout() async {
    await _prefs!.remove('sessionToken');
    _user = null;
  }

  // // 持久化Profile信息
  // static saveProfile() =>
  //     _prefs.setString("profile", jsonEncode(profile.toJson()));
}
