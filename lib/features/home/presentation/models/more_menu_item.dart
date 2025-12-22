import 'package:flutter/material.dart';

class MoreMenuItem {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final void Function(BuildContext) onTap;

  MoreMenuItem({
    required this.icon,
    required this.title,
    this.iconColor,
    required this.onTap,
  });
}
