import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:weno/providers/_providers.dart';

class PizzaAnimation extends StatelessWidget {
  const PizzaAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final pizzaProv = Provider.of<PizzaProvider>(context);

    return SizedBox(
      height: 220,
      width: 230,
      child: RiveAnimation.asset(
        'assets/weno.riv',
        artboard: 'Pizza',
        fit: BoxFit.cover,
        onInit: pizzaProv.onRiveInit,
      ),
    );
  }
}
