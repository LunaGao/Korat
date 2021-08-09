class ApiResponseModel {
  bool isSuccess;
  String errorMessage;
  dynamic message;

  ApiResponseModel({
    this.isSuccess = false,
    this.errorMessage = '',
    this.message = '',
  });
}
