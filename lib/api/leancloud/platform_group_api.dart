import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/models/platform_group.dart';

class PlatformGroupApi {
  Future<ResponseModel<List<PlatformGroup>>> getMyPlatformGroups(
      String currentUserId) async {
    var response = await BaseApi().getWithAuth(
      '/classes/PlatformGroup',
      {
        'where': {
          'owner': {
            "__type": "Pointer",
            "className": "_User",
            "objectId": currentUserId,
          },
        }
      },
    );
    return _getListForPlatformGroup(response);
  }

  Future<ResponseModel> putPlatformName(
    String name,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/PlatformGroup',
      {
        'name': name,
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  Future<ResponseModel> putDataPlatform(
    String platformId,
    String name,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/PlatformGroup',
      {
        'name': name,
        'dataPlatform': {
          "__type": "Pointer",
          "className": "Platform",
          "objectId": platformId,
        },
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  Future<ResponseModel> putPublishPlatform(
    String platformId,
    String name,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/PlatformGroup',
      {
        'name': name,
        'publishPlatform': {
          "__type": "Pointer",
          "className": "Platform",
          "objectId": platformId,
        },
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  ResponseModel<List<PlatformGroup>> _getListForPlatformGroup(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<List<PlatformGroup>> returnValue =
        ResponseModel<List<PlatformGroup>>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    List<PlatformGroup> data = [];
    // _JsonMap ({results: [
    //{default: false, name: 123123, owner:
    //{__type: Pointer, className: _User, objectId: 6110e701cc3b443d8d365492},
    //createdAt: 2021-08-17T12:35:56.750Z, updatedAt: 2021-08-17T12:35:56.750Z,
    //objectId: 611bad2cf8503b7c87a09b7f}]})
    for (Map item in response.message["results"]) {
      var platfromGtoup = PlatformGroup(item['name']);
      platfromGtoup.objectId = item['objectId'];
      if (item.containsKey('dataPlatform')) {
        platfromGtoup.dataPlatformId = item['dataPlatform']['objectId'];
      }
      if (item.containsKey('publishPlatform')) {
        platfromGtoup.publishPlatformId = item['publishPlatform']['objectId'];
      }
      data.add(platfromGtoup);
    }
    returnValue.message = data;
    return returnValue;
  }
}
