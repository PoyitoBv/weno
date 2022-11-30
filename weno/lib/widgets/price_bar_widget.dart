import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/_providers.dart';
import '../themes/app_theme.dart';
import '_widgets.dart';

class PriceBar extends StatefulWidget {
  final String label, detail, label2, detail2, button;
  final double value, value2;
  final bool important, important2;
  final Function() buttonOnTap;
  final Function()? hack;

  const PriceBar({
    super.key,
    required this.label,
    required this.value,
    this.detail = '',
    required this.label2,
    required this.value2,
    this.detail2 = '',
    this.important = false,
    this.important2 = false,
    required this.button,
    required this.buttonOnTap,
    this.hack,
  });

  @override
  State<PriceBar> createState() => _PriceBarState();
}

class _PriceBarState extends State<PriceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<RelativeRect> _animation;

  late int _thisPage;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 130, 0, 0),
      end: const RelativeRect.fromLTRB(0, 0, 0, 130),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    ))
      ..addStatusListener((status) => _pop(status));
    // ..addListener(() {});

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pop(AnimationStatus status) {
    if (status != AnimationStatus.dismissed &&
        status != AnimationStatus.completed) return;

    final navProv = Provider.of<NavigationProvider>(context, listen: false);

    if (status == AnimationStatus.completed) {
      navProv.nextAnimations = null;
      // navProv.currentPage += 1;
      _thisPage = navProv.currentPage;
    }
    if (status == AnimationStatus.dismissed) {
      navProv.willPop = false;
      // navProv.currentPage -= 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProv = Provider.of<NavigationProvider>(context);
    if (navProv.nextAnimations == true) _controller.forward();
    if (navProv.willPop == true && navProv.currentPage == _thisPage) {
      _controller.reverse();
    }

    return Positioned(
      bottom: -130,
      child: SizedBox(
        height: 260,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PositionedTransition(
              rect: _animation,
              child: _PriceBar(
                label: widget.label,
                value: '${widget.value}',
                detail: widget.detail,
                important: widget.important,
                label2: widget.label2,
                value2: widget.value2.toStringAsFixed(2),
                detail2: widget.detail2,
                important2: widget.important2,
                button: widget.button,
                buttonOnTap: widget.buttonOnTap,
                hack: widget.hack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceBar extends StatelessWidget {
  final String label, value, detail, label2, value2, detail2, button;
  final bool important, important2;
  final Function() buttonOnTap;
  final Function()? hack;

  const _PriceBar({
    Key? key,
    required this.label,
    required this.value,
    required this.detail,
    required this.important,
    required this.label2,
    required this.value2,
    required this.detail2,
    required this.important2,
    required this.button,
    required this.buttonOnTap,
    this.hack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 130,
      decoration: const BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: hack,
            child: Price(
              label: label,
              value: value,
              detail: detail,
              important: important,
            ),
          ),
          const _Divider(),
          Price(
            label: label2,
            value: value2,
            detail: detail2,
            important: important2,
          ),
          AddButton(button, elevation: 0, onTap: buttonOnTap),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7,
      width: 7,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.white,
      ),
    );
  }
}
