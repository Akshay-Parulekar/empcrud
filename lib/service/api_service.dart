import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../util/utils.dart';

String myBaseUrl = _isRunningOnEmulator()?"http://10.0.2.2:8080":"http://192.168.42.38:8080";
// String myBaseUrl = "https://ems.asianinfotech.co.in";

class Endpoints
{
  static String emp = "/emp/";
}

InterceptorsWrapper getInterceptor(BuildContext context)
{
  return InterceptorsWrapper(
    onError: (error, handler) {
      switch(error.type) {
        case DioExceptionType.connectionTimeout:
          showSnackbar(context, "Connection Timeout");
        case DioExceptionType.sendTimeout:
          showSnackbar(context, "Send Request Timeout");
        case DioExceptionType.receiveTimeout:
          showSnackbar(context, "Receieve Request Timeout");
        case DioExceptionType.connectionError:
          showSnackbar(context, "Connection Error");
        default:
          showSnackbar(context, "Unexpected Error : ${error.message}");
      }
    },
  );
}

bool _isRunningOnEmulator() {
  if (!Platform.isAndroid) return false;
  String model = Platform.environment["ANDROID_RUNTIME"] ?? "";
  return model.toLowerCase().contains("ranchu") || model.toLowerCase().contains("goldfish");
}
