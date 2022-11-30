import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/_providers.dart';

class MyCustomAnimatedRoute extends PageRouteBuilder {
  final Widget enterWidget;
  final Alignment alignment;

  MyCustomAnimatedRoute({required this.enterWidget, required this.alignment})
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
          transitionDuration: const Duration(milliseconds: 1500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final navProv = Provider.of<NavigationProvider>(context);

            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.fastOutSlowIn)
              ..addStatusListener((status) {
                if (status == AnimationStatus.dismissed) navProv.addCart = null;
              });

            return ScaleTransition(
              alignment: navProv.addCart ?? alignment,
              scale: animation,
              child: child,
            );
          },
        );
}
