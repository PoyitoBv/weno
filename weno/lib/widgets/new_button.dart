import 'package:flutter/material.dart';
import 'package:weno/themes/app_theme.dart';

class NewButton extends StatelessWidget {
  final Function() onPressed;

  const NewButton(this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 65,
      margin: const EdgeInsets.only(bottom: 30),
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 0,
        backgroundColor: AppTheme.black,
        child: const Icon(Icons.add_rounded, size: 50, color: AppTheme.white),
      ),
    );
  }
}
