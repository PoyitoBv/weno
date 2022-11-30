import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:weno/providers/_providers.dart';

import '../transitions/_transitions.dart';
import '../pages/_pages.dart';
import '../themes/app_theme.dart';
import 'package:weno/widgets/_widgets.dart';

class MyAppBar extends StatelessWidget {
  final bool back;

  const MyAppBar({super.key, this.back = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _BackButton(back: back),
          const _AppName(),
          Visibility(
            visible: !back ? true : false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: SquareButton(() {
              Navigator.of(context).push(
                MyCustomAnimatedRoute(
                  enterWidget: const TransitionPage(CartPage()),
                  alignment: const Alignment(0.8, -0.8),
                ),
              );
            }, Icons.shopping_cart),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  const _BackButton({
    Key? key,
    required this.back,
  }) : super(key: key);

  final bool back;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late int _thisPage;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn)
      ..addStatusListener((status) => check4Close(status));
    super.initState();
  }

  void check4Close(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    final navProv = Provider.of<NavigationProvider>(context, listen: false);
    _thisPage = navProv.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final navProv = Provider.of<NavigationProvider>(context);

    if (navProv.nextAnimations == true) _controller.forward();
    if (navProv.willPop == true && _thisPage == navProv.currentPage) {
      _controller.reverse();
    }

    return FadeTransition(
      opacity: _animation,
      child: Visibility(
        visible: widget.back,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: SquareButton(() {
          final navigationProv =
              Provider.of<NavigationProvider>(context, listen: false);

          if (navigationProv.nextAnimations != null) return;
          navigationProv.willPop = true;
        }, Icons.arrow_back, background: AppTheme.yellow),
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'WENO',
      style: TextStyle(
        color: AppTheme.black,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
