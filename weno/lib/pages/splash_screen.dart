import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../providers/_providers.dart';
import '../themes/app_theme.dart';
import './_pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navProv = Provider.of<NavigationProvider>(context);

    //Todo: Debería cambiar este tipo de "navegación" por una navegación real
    // que al terminar la animación (a la cual se le quitaria el circulo que
    // se hace grande al final), se haga una animación la cual haga una tran-
    // cición exactamente igual que en la animación.
    // Esto para evitar el pantallaso blanco que hay de fondo cuando hace el
    // cambio.

    return navProv.splashScreen
        ? const Scaffold(body: _Animacion())
        : const HomePage();
  }
}

class _Animacion extends StatefulWidget {
  const _Animacion();

  @override
  State<_Animacion> createState() => _AnimacionState();
}

class _AnimacionState extends State<_Animacion> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    _controller = OneShotAnimation(
      'inicio',
      autoplay: true,
      onStart: _end,
    );

    super.initState();
  }

  void _end() async {
    final navProv = Provider.of<NavigationProvider>(context, listen: false);

    await Future.delayed(const Duration(milliseconds: 4500));

    navProv.spashScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.yellow,
      child: RiveAnimation.asset(
        'assets/weno.riv',
        artboard: 'SplashScreen',
        controllers: [_controller],
        fit: BoxFit.cover,
      ),
    );
  }
}
