import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weno/providers/_providers.dart';

class TransitionPage extends StatefulWidget {
  final Widget child;

  const TransitionPage(this.child, {super.key});

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage>
    with TickerProviderStateMixin {
  bool backPressed = false;

  late AnimationController controllerToIncreasingCurve;

  late AnimationController controllerToDecreasingCurve;

  late Animation<double> animationToIncreasingCurve;

  late Animation<double> animationToDecreasingCurve;

  late int _thisPage;

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
    )
      ..addStatusListener((status) => nextAnimations(status))
      ..addListener(() => setState(() {}));

    animationToDecreasingCurve = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: controllerToDecreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() => setState(() {}));

    controllerToIncreasingCurve.forward();

    super.initState();
  }

  @override
  void dispose() {
    controllerToIncreasingCurve.dispose();
    controllerToDecreasingCurve.dispose();
    super.dispose();
  }

  Future<bool> _pop() async {
    final navProv = Provider.of<NavigationProvider>(context, listen: false);
    final cartProv = Provider.of<CartProvider>(context, listen: false);

    if (navProv.nextAnimations != null) return false;
    navProv.willPop ??= true;
    if (navProv.willPop == true) return false;

    backPressed = true;
    controllerToDecreasingCurve.forward();

    navProv.currentPage -= 1;
    navProv.willPop = null;

    cartProv.fix();

    Navigator.pop(context);
    return true;
  }

  void nextAnimations(AnimationStatus status) {
    final navProv = Provider.of<NavigationProvider>(context, listen: false);

    if (status == AnimationStatus.forward) navProv.nextAnimations = false;
    if (status == AnimationStatus.completed) {
      navProv.nextAnimations = true;
      navProv.currentPage += 1;
      _thisPage = navProv.currentPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProv = Provider.of<NavigationProvider>(context);

    if (navProv.willPop == false && _thisPage == navProv.currentPage) _pop();

    return WillPopScope(
      onWillPop: _pop,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          backPressed == false
              ? animationToIncreasingCurve.value
              : animationToDecreasingCurve.value,
        ),
        child: widget.child,
      ),
    );
  }
}
