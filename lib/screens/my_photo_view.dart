import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MyPhotoView extends StatelessWidget {
  final String url;

  const MyPhotoView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
          ),
        ],
      ),
    );
  }
}
