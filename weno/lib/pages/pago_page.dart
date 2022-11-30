import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:weno/providers/_providers.dart';

class PagoPage extends StatelessWidget {
  const PagoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    void pop() {
      Navigator.pop(context);
    }

    if (cartProv.pop) pop();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          RiveAnimation.asset(
            'assets/weno.riv',
            artboard: 'SplashScreen',
            fit: BoxFit.cover,
            onInit: cartProv.onRiveInit,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .25,
            child: Text(cartProv.pago, style: const TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }
}
