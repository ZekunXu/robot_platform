import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
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
  if (received >= total) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'progress_bar',
            title: 'Download finished',
            body: 'filename.txt',
            locked: false));
    received++;
  } else {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'progress_bar',
            title:
                'Downloading (${(received / (1024 * 1024)).toStringAsFixed(2)}MB of ${(total / (1024 * 1024)).toStringAsFixed(2)}MB)',
            notificationLayout: NotificationLayout.ProgressBar,
            progress: min((received / total * 100).round(), 100),
            locked: true));
  }
}
