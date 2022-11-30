import 'package:flutter/material.dart';
import 'package:weno/themes/app_theme.dart';

class Price extends StatelessWidget {
  final String label, value, detail;
  final bool important;

  const Price({
    super.key,
    required this.label,
    required this.value,
    this.detail = '',
    this.important = false,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle styleLabel = const TextStyle(color: AppTheme.white, fontSize: 13);

    TextStyle styleValue = const TextStyle(
      color: AppTheme.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    TextStyle styleDetail = TextStyle(
      color: AppTheme.white.withOpacity(.5),
      fontSize: 11,
    );

    if (important) {
      styleValue = const TextStyle(
        color: AppTheme.yellow,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: styleLabel),
        Text('\$$value', style: styleValue),
        Text(detail, style: styleDetail),
      ],
    );
  }
}
