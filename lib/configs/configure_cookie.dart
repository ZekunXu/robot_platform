import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'configure_url.dart';

class MyCookie {
  /// 使用 PersisCookieJar 方便存储
  static PersistCookieJar _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }
}
