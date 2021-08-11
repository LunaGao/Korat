import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';

class UserApi {
  Future<ResponseModel<dynamic>> signup(String email, String password) async {
    return BaseApi().post('/users', {
      "username": email[0].toUpperCase(),
      "password": password,
      "email": email,
    });
  }

  Future<ResponseModel<dynamic>> signin(String email, String password) async {
    return BaseApi().post('/login', {
      "password": password,
      "email": email,
    });
  }

  Future<ResponseModel<dynamic>> me() async {
    return BaseApi().getWithAuth('/users/me', {});
  }

  Future<ResponseModel<dynamic>> requestEmailVerify(String email) async {
    return BaseApi().post('/requestEmailVerify', {
      "email": email,
    });
  }
}
