import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/models/platform.dart';
import 'package:korat/models/platform_group.dart';

class PlatformGroupApi {
  Future<ResponseModel<List<PlatformGroup>>> getMyPlatformGroups(
      String currentUserId) async {
    var response = await BaseApi().getWithAuth(
      '/classes/PlatformGroup?include=dataPlatform,publishPlatform',
      {
        'where': {
          'owner': {
            "__type": "Pointer",
            "className": "_User",
            "objectId": currentUserId,
          },
        },
      },
    );
    return _getListForPlatformGroup(response);
  }

  Future<ResponseModel> createPlatformGroup(
    String name,
    String dataPlatformObjectId,
    String? publishPlatformObjectId,
    String currentUserId,
  ) async {
    var data = {
      'name': name,
      'dataPlatform': {
        "__type": "Pointer",
        "className": "Platform",
        "objectId": dataPlatformObjectId,
      },
      'owner': {
        "__type": "Pointer",
        "className": "_User",
        "objectId": currentUserId,
      }
    };
    if (publishPlatformObjectId != null) {
      data.addAll({
        'publishPlatform': {
          "__type": "Pointer",
          "className": "Platform",
          "objectId": publishPlatformObjectId,
        },
      });
    }
    return BaseApi().postWithAuth(
      '/classes/PlatformGroup',
      data,
    );
  }

  Future<ResponseModel> updatePlatformGroup(
    String objectId,
    String name,
    String dataPlatformObjectId,
    String? publishPlatformObjectId,
  ) async {
    var data = {
      'name': name,
      'dataPlatform': {
        "__type": "Pointer",
        "className": "Platform",
        "objectId": dataPlatformObjectId,
      },
    };
    if (publishPlatformObjectId != null) {
      data.addAll({
        'publishPlatform': {
          "__type": "Pointer",
          "className": "Platform",
          "objectId": publishPlatformObjectId,
        },
      });
    }
    return BaseApi().putWithAuth(
      '/classes/PlatformGroup/$objectId',
      data,
    );
  }

  Future<ResponseModel> deletePlatformGroup(
    String objectId,
  ) async {
    return BaseApi().deleteWithAuth(
      '/classes/PlatformGroup/$objectId',
      {},
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
        PlatformModel platformModel = PlatformModel();
        platformModel.bucket = item['dataPlatform']['bucket'];
        platformModel.objectId = item['dataPlatform']['objectId'];
        platformModel.platform = item['dataPlatform']['platform'];
        platformModel.keySecret = item['dataPlatform']['keySecret'];
        platformModel.keyId = item['dataPlatform']['keyId'];
        platformModel.endPoint = item['dataPlatform']['endPoint'];
        platformModel.bucket = item['dataPlatform']['bucket'];
        platfromGtoup.dataPlatform = platformModel;
      }
      if (item.containsKey('publishPlatform')) {
        PlatformModel platformModel = PlatformModel();
        platformModel.bucket = item['publishPlatform']['bucket'];
        platformModel.objectId = item['publishPlatform']['objectId'];
        platformModel.platform = item['publishPlatform']['platform'];
        platformModel.keySecret = item['publishPlatform']['keySecret'];
        platformModel.keyId = item['publishPlatform']['keyId'];
        platformModel.endPoint = item['publishPlatform']['endPoint'];
        platformModel.bucket = item['publishPlatform']['bucket'];
        platfromGtoup.publishPlatform = platformModel;
      }
      data.add(platfromGtoup);
    }
    returnValue.message = data;
    return returnValue;
  }
}
