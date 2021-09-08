import 'package:korat/api/base_model/response_model.dart';
import 'package:korat/api/leancloud/base_api.dart';
import 'package:korat/models/project.dart';

class ProjectApi {
  Future<ResponseModel<ProjectModel>> getProjectById(String objectId) async {
    var response =
        await BaseApi().getWithAuth('/classes/Project/$objectId', {});

    return _getProject(response);
  }

  Future<ResponseModel<List<ProjectModel>>> getMyProjects(
      String currentUserId) async {
    var response = await BaseApi().getWithAuth(
      '/classes/Project',
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
    return _getListForProject(response);
  }

  Future<ResponseModel> updateProject(
    String objectId,
    String name,
    String endpoint,
    String bucket,
    String accessKeyId,
    String accessKeySecret,
    String platformConfig,
  ) async {
    return BaseApi().putWithAuth(
      '/classes/Project/$objectId',
      {
        'name': name,
        'endPoint': endpoint,
        'bucket': bucket,
        'keyId': accessKeyId,
        'keySecret': accessKeySecret,
        'platform': platformConfig,
      },
    );
  }

  Future<ResponseModel> createProject(
    String name,
    String endpoint,
    String bucket,
    String accessKeyId,
    String accessKeySecret,
    String platformConfig,
    String currentUserId,
  ) async {
    return BaseApi().postWithAuth(
      '/classes/Project',
      {
        'name': name,
        'endPoint': endpoint,
        'bucket': bucket,
        'keyId': accessKeyId,
        'keySecret': accessKeySecret,
        'platform': platformConfig,
        'owner': {
          "__type": "Pointer",
          "className": "_User",
          "objectId": currentUserId,
        }
      },
    );
  }

  Future<ResponseModel> deleteProject(
    String objectId,
  ) async {
    return BaseApi().deleteWithAuth(
      '/classes/Project/$objectId',
      {},
    );
  }

  ResponseModel<List<ProjectModel>> _getListForProject(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<List<ProjectModel>> returnValue =
        ResponseModel<List<ProjectModel>>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    List<ProjectModel> data = [];
    for (Map item in response.message["results"]) {
      var project = ProjectModel();
      project.objectId = item['objectId'];
      project.name = item['name'];
      project.platform = item['platform'];
      project.keySecret = item['keySecret'];
      project.keyId = item['keyId'];
      project.endPoint = item['endPoint'];
      project.bucket = item['bucket'];
      data.add(project);
    }
    returnValue.message = data;
    return returnValue;
  }

  ResponseModel<ProjectModel> _getProject(
    ResponseModel<dynamic> response,
  ) {
    ResponseModel<ProjectModel> returnValue = ResponseModel<ProjectModel>();
    returnValue.isSuccess = response.isSuccess;
    returnValue.errorMessage = response.errorMessage;
    if (!returnValue.isSuccess) {
      return returnValue;
    }
    var item = response.message;
    var project = ProjectModel();
    project.objectId = item['objectId'];
    project.name = item['name'];
    project.platform = item['platform'];
    project.keySecret = item['keySecret'];
    project.keyId = item['keyId'];
    project.endPoint = item['endPoint'];
    project.bucket = item['bucket'];
    returnValue.message = project;
    return returnValue;
  }
}
