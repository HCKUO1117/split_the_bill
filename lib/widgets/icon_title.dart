import 'package:flutter/material.dart';

class IconTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  final double? horizonPadding;

  const IconTitle({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.horizonPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(width: horizonPadding ?? 16),
            Icon(icon),
            const SizedBox(width: 8),
            Text(title),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
