import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class SquareButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final Color background;
  final bool active;

  const SquareButton(
    this.onTap,
    this.icon, {
    super.key,
    this.background = AppTheme.white,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: active ? AppTheme.red : AppTheme.black),
      ),
    );
  }
}
