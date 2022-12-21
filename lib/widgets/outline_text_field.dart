import 'package:flutter/material.dart';

class OutlineTextField extends StatelessWidget {
  final IconData? iconData;
  final bool obscure;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final Function(String)? onChange;

  const OutlineTextField({
    Key? key,
    this.iconData,
    this.obscure = false,
    required this.controller,
    this.focusNode,
    this.onSubmit,
    this.textInputType,
    this.textInputAction,
    this.errorText,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmit,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      onChanged: onChange,
      decoration: InputDecoration(
          prefixIcon: iconData != null ? Icon(iconData) : null,
          contentPadding: const EdgeInsets.all(4),
          border: const OutlineInputBorder(),
          errorText: errorText),
    );
  }
}
