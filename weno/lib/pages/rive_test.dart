import 'package:flutter/material.dart';

import 'package:rive/rive.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (_, i) {
            return Container(
              // margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(5),
              color: Colors.purple,
              height: MediaQuery.of(context).size.height,
              width: 20,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (_, j) {
                  Widget child = const TestAnimation();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 20,
                    width: 20,
                    color: Colors.green,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TestAnimation extends StatelessWidget {
  const TestAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/test.riv',
      artboard: 'hola',
      fit: BoxFit.cover,
      onInit: onRiveInit,
    );
  }

  void onRiveInit(Artboard art) {
    final controller = StateMachineController.fromArtboard(
      art,
      'main',
      // onStateChange: _onStateChange,
    );
    art.addController(controller!);
  }
}
