import 'package:flutter/material.dart';

class ResponseModel<@required T> {
  bool isSuccess;
  String errorMessage;
  T? message;

  ResponseModel({
    this.isSuccess = false,
    this.errorMessage = '',
    this.message,
  });
}
