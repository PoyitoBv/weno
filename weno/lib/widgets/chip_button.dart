import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/_providers.dart';
import '../themes/app_theme.dart';

class ChipButtons extends StatelessWidget {
  const ChipButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        ChipButton('Tradicionales'),
        SizedBox(width: 10),
        ChipButton('Especiales'),
        SizedBox(width: 10),
        ChipButton('Explora'),
      ],
    );
  }
}

class ChipButton extends StatelessWidget {
  final String name;

  const ChipButton(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return ElevatedButton(
      onPressed: () {
        navigationProvider.chipActive = name;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: navigationProvider.chipActive != name
            ? AppTheme.yellowLow
            : AppTheme.black,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          color: navigationProvider.chipActive == name
              ? AppTheme.white
              : AppTheme.black,
        ),
      ),
    );
  }
}

/*

            TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 12,
                  color: const Color(0xff211a1d),
                  fontWeight: FontWeight.w500,
                ),
*/
