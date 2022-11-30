import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:weno/providers/_providers.dart';

class PagoPage extends StatelessWidget {
  const PagoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
            Positioned(
              bottom: 20,
              child: Visibility(
                visible: cartProv.pop,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Hay un pequeño error que no alcancé a corregir, para seguir utilizando hay que reiniciar la app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.3),
                      fontSize: 15,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
