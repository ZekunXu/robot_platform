import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'configure_cookie.dart';

class MyDio {
  static Dio _dio = new Dio();
  static Future<Dio> get dio async {
    _dio.interceptors.add(CookieManager(await MyCookie.cookieJar));
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    };

    return _dio;
  }
}

class MyJsonDio {
  static Dio _dio = new Dio();
  static Future<Dio> get dio async {
    _dio.interceptors.add(CookieManager(await MyCookie.cookieJar));
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json;charset=UTF-8",
    };
    return _dio;
  }
}
