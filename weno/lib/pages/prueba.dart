import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:rive/rive.dart';

import 'package:weno/widgets/price_bar_widget.dart';

//* Animacion de redondeado de esquinas al hacer la trancisión de pantalla

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  bool backPressed = false;

  late AnimationController controllerToIncreasingCurve;

  late AnimationController controllerToDecreasingCurve;

  late Animation<double> animationToIncreasingCurve;

  late Animation<double> animationToDecreasingCurve;

  @override
  void initState() {
    controllerToIncreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controllerToDecreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationToIncreasingCurve = Tween<double>(begin: 500, end: 0).animate(
      CurvedAnimation(
        parent: controllerToIncreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    animationToDecreasingCurve = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: controllerToDecreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    controllerToIncreasingCurve.forward();

    super.initState();
  }

  @override
  void dispose() {
    controllerToIncreasingCurve.dispose();
    controllerToDecreasingCurve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backPressed = true;
        controllerToDecreasingCurve.forward();
        return true;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          backPressed == false
              ? animationToIncreasingCurve.value
              : animationToDecreasingCurve.value,
        ),
      ),
    );
  }
}

//* Animacion de Posicion - Pruebas

class Prueba extends StatefulWidget {
  // final Pizza pizza;

  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> with TickerProviderStateMixin {
  late AnimationController controllerOpenPrice;

  late Animation<RelativeRect> animationOpenPriceBar;

  @override
  void initState() {
    controllerOpenPrice = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // const double smallLogo = 100;
    // const double bigLogo = 200;
    // const Size biggest = Size(100, 100);

    animationOpenPriceBar = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 130, 0, 0),
      end: const RelativeRect.fromLTRB(0, 0, 0, 130),
    ).animate(CurvedAnimation(
      parent: controllerOpenPrice,
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    ))
      ..addListener(() {
        log('${controllerOpenPrice.isCompleted}');
      });

    // controllerOpenPrice.forward(from: 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -130,
            child: Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              color: Colors.green[100],
              child: Stack(
                children: [
                  PositionedTransition(
                    rect: animationOpenPriceBar,
                    // bottom: 0
                    child: PriceBar(
                      label: 'Hola',
                      value: 23,
                      label2: 'Adios',
                      value2: 987,
                      button: 'Bien',
                      buttonOnTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controllerOpenPrice.isCompleted) {
            controllerOpenPrice.reverse();
          } else {
            controllerOpenPrice.forward();
          }
        },
        elevation: 0,
      ),
    );
  }
}

class SimpleStateMachine extends StatefulWidget {
  const SimpleStateMachine({Key? key}) : super(key: key);

  @override
  State<SimpleStateMachine> createState() => _SimpleStateMachineState();
}

class _SimpleStateMachineState extends State<SimpleStateMachine> {
  SMITrigger? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'bumpy');
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('bump') as SMITrigger;
  }

  void _hitBump() => _bump?.fire();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _hitBump,
          child: RiveAnimation.network(
            'https://cdn.rive.app/animations/vehicles.riv',
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}
