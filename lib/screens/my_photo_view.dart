import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:split_the_bill/utils/download.dart';

class MyPhotoView extends StatefulWidget {
  final String url;

  const MyPhotoView({Key? key, required this.url}) : super(key: key);

  @override
  State<MyPhotoView> createState() => _MyPhotoViewState();
}

class _MyPhotoViewState extends State<MyPhotoView> {
  final _receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, DownloadingService.downloadingPortName);
    FlutterDownloader.registerCallback(DownloadingService.downloadingCallBack);
    _receivePort.listen((message) {
      print('Got message from port: $message');
    });
  }

  @override
  void dispose() {
    _receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(widget.url),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: MediaQuery.of(context).padding.top,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.white,shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    _downloadFile(widget.url);
                  },
                  icon: const Icon(Icons.download,color: Colors.white,shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _downloadFile(String url) async {
    try {
      await DownloadingService.createDownloadTask(url.toString());
    } catch (e) {
      print("error");
    }
  }
}
