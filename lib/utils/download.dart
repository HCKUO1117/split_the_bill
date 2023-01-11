import 'dart:io';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadingService {
  static const downloadingPortName = 'downloading';

  static Future<void> createDownloadTask(String url) async {
    final _storagePermission = await _permissionGranted();
    print('Current storage permission: $_storagePermission');

    if (!_storagePermission) {
      final _status = await Permission.storage.request();
      if (!_status.isGranted) {
        print('Permission wasnt granted. Cancelling downloading');
        return;
      }
    }

    final _path = await _getPath();
    print('Downloading path $_path');

    if (_path == null) {
      print('Got empty path. Cannot start downloading');
      return;
    }

    final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: _path,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification: true,
        // click on notification to open downloaded file (for Android)
        saveInPublicStorage: true);

    await Future.delayed(const Duration(seconds: 1));

    if (taskId != null) {
      await FlutterDownloader.open(taskId: taskId);
    }
  }

  static Future<bool> _permissionGranted() async {
    return await Permission.storage.isGranted;
  }

  static Future<String?> _getPath() async {
    if (Platform.isAndroid) {
      final _externalDir = await getExternalStorageDirectory();
      return _externalDir?.path;
    }

    return (await getApplicationDocumentsDirectory()).absolute.path;
  }

  static downloadingCallBack(id, status, progress) {
    final _sendPort = IsolateNameServer.lookupPortByName(downloadingPortName);

    if (_sendPort != null) {
      _sendPort.send([id, status, progress]);
    } else {
      print('SendPort is null. Cannot find isolate $downloadingPortName');
    }
  }
}