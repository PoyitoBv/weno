import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class AddButton extends StatelessWidget {
  final String button;
  final double elevation;
  final Function() onTap;

  const AddButton(
    this.button, {
    super.key,
    required this.onTap,
    this.elevation = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        shadowColor: AppTheme.yellow,
        backgroundColor: AppTheme.yellow,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
      ),
      child: Text(
        button,
        style: const TextStyle(
          color: AppTheme.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
