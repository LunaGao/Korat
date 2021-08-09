import 'package:korat/api/base_model/base_model.dart';
import 'package:korat/api/leancloud/base_api.dart';

class UserApi {
  Future<ApiResponseModel> signup(String email, String password) async {
    return BaseApi().post('/users', {
      "username": email[0].toUpperCase(),
      "password": password,
      "email": email,
    });
  }

  Future<ApiResponseModel> signin(String email, String password) async {
    return BaseApi().post('/login', {
      "password": password,
      "email": email,
    });
  }

  Future<ApiResponseModel> me() async {
    return BaseApi().getWithAuth('/users/me', {});
  }

  Future<ApiResponseModel> requestEmailVerify(String email) async {
    return BaseApi().post('/requestEmailVerify', {
      "email": email,
    });
  }
}
