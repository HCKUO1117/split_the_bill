import 'package:flutter/material.dart';

class ShowSnack {
  static show(BuildContext context, {required String content}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }
}
