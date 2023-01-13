import 'package:flutter/material.dart';
import 'package:split_the_bill/widgets/loading_widget.dart';

class LoadingCover extends StatefulWidget {
  final bool loading;
  final Widget child;

  const LoadingCover({
    Key? key,
    required this.loading,
    required this.child,
  }) : super(key: key);

  @override
  State<LoadingCover> createState() => _LoadingCoverState();
}

class _LoadingCoverState extends State<LoadingCover> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.loading) const LoadingWidget(),
      ],
    );
  }
}
