import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/_models.dart';
import '../themes/app_theme.dart';
import '../providers/_providers.dart';
import '../transitions/_transitions.dart';
import '../widgets/_widgets.dart';
import '_pages.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const MyAppBar(back: true),
                const SizedBox(height: 20),
                const _Creditos(),
                const SizedBox(height: 20),
                cartProv.pizzas.isNotEmpty
                    ? _Cards(cartProv.pizzas)
                    : Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const Text(
                          'El Carrito está vacío :c',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
              ],
            ),

            PriceBar(
              button: 'Pay',
              label: 'Total',
              value: cartProv.prices,
              detail: '30% Dsto.',
              important: true,
              label2: 'Antes',
              value2: cartProv.prices * 1.3,
              buttonOnTap: () {
                if (cartProv.pizzas.isEmpty) return;

                cartProv.pagoStatus = null;
                cartProv.pop = false;

                Navigator.of(context).push(
                  MyCustomAnimatedRoute(
                    enterWidget: const TransitionPage(PagoPage()),
                    alignment: const Alignment(0, 0),
                  ),
                );
              },
              hack: () {
                final cartProv =
                    Provider.of<CartProvider>(context, listen: false);

                cartProv.creditos += 20.0;
              },
            ),

            // Price Bar
          ],
        ),
      ),
    );
  }
}

class _Creditos extends StatefulWidget {
  const _Creditos();

  @override
  State<_Creditos> createState() => _CreditosState();
}

class _CreditosState extends State<_Creditos> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 10),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    )..addStatusListener((status) => _rebote(status));

    super.initState();
  }

  double _creditos = 100.0;

  void _rebote(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) return;

    final cartProv = Provider.of<CartProvider>(context, listen: false);

    _controller.forward();

    _creditos = cartProv.creditos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    if (cartProv.creditos != _creditos) _controller.reverse();

    return ScaleTransition(
      scale: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.yellowLow,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text('Creditos: \$$_creditos', textAlign: TextAlign.center),
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  final List<Pizza> pizzas;

  const _Cards(this.pizzas);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children =
        pizzas.map<Widget>((e) => CartCard(e)).toList();

    children.add(const SizedBox(height: 180));

    return Expanded(
      child: SizedBox(
        width: 330,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: children,
        ),
      ),
    );
  }
}
