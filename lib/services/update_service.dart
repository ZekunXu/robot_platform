import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_platform/configs/configure_dio.dart';
import 'package:robot_platform/configs/configure_url.dart';
import 'package:robot_platform/configs/configure_global_param.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<Response> getAppUpdateInfo() async {
  String url = ApiUrl.stdHttpRequestUrl + "download/appInfo";

  Response response = await (await MyJsonDio.dio).get(url);

  return response;
}

Future<File> downloadApp({@required String url}) async {
  Directory storageDir = await getExternalStorageDirectory();
  String storagePath = storageDir.path;
  File file = new File("$storagePath/app-release.apk");

  if (!file.existsSync()) {
    file.createSync();
  }

  try {
    Response response = await (await MyJsonDio.dio).get(url,
        onReceiveProgress: _showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ));

    file.writeAsBytesSync(response.data);

    return file;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    print(e);
  }
}

void _showDownloadProgress(num received, num total) {

}
