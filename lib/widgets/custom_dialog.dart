import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class CustomDialog extends StatefulWidget {
  final String content;
  final VoidCallback? onTap;
  final String? confirmText;
  final Widget? child;
  final List<Widget>? actions;
  final VoidCallback? helpTap;
  final bool? backStack;

  const CustomDialog({
    Key? key,
    required this.content,
    this.onTap,
    this.confirmText,
    this.child,
    this.actions,
    this.helpTap,
    this.backStack,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.backStack ?? true;
      },
      child: AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.content),
            widget.child ?? Container(),
          ],
        ),
        actions: widget.actions ??
            [
              TextButton(
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(
                    color: Colors.black54
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                onPressed: widget.onTap ??
                    () {
                      Navigator.of(context).pop(true);
                    },
                child: Text(
                  widget.confirmText ?? S.of(context).confirm,
                  style: TextStyle(
                      color: Constants.primaryColor
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
