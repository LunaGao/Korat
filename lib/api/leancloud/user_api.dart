import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/base_model/user.dart';
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

  Future<ResponseModel<User>> me() async {
    User user = User();
    var meResponse = await BaseApi().getWithAuth('/users/me', {});
    if (meResponse.isSuccess) {
      user.email = meResponse.message['email'];
      user.emailVerified = meResponse.message['emailVerified'];
      user.objectId = meResponse.message['objectId'];
    }
    ResponseModel<User> returnValue = ResponseModel<User>();
    returnValue.isSuccess = meResponse.isSuccess;
    returnValue.errorMessage = meResponse.errorMessage;
    returnValue.message = user;
    return returnValue;
  }

  Future<ResponseModel<dynamic>> requestEmailVerify(String email) async {
    return BaseApi().post('/requestEmailVerify', {
      "email": email,
    });
  }
}
