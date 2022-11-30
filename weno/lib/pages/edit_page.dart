import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/_providers.dart';
import '../widgets/_widgets.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pizzaProv = Provider.of<PizzaProvider>(context);
    final pizza = pizzaProv.currentPizza;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PriceBar(
              button: 'Add',
              label: 'Ahora',
              value: pizza!.price,
              detail: '30% Dsto.',
              important: true,
              label2: 'Antes',
              value2: double.parse((pizza.price * 1.3).toStringAsFixed(2)),
              buttonOnTap: () {
                final navProv =
                    Provider.of<NavigationProvider>(context, listen: false);

                if (navProv.nextAnimations != null) return;

                final cartProv =
                    Provider.of<CartProvider>(context, listen: false);

                if (cartProv.pizzas.isNotEmpty) {
                  for (int i = 0; i < cartProv.pizzas.length; i++) {
                    if (cartProv.pizzas[i].id == pizza.id) {
                      cartProv.replace(i, pizza);

                      navProv.addCart = const Alignment(0, 0);
                      navProv.willPop = true;

                      return;
                    }
                  }
                }

                cartProv.pizzas.add(pizza);

                navProv.addCart = const Alignment(0.8, -0.8);
                navProv.willPop = true;
              },
            ),
            Column(
              children: [
                const MyAppBar(back: true),
                const SizedBox(height: 40),
                EditCard(
                  name: pizza.name,
                  description: pizza.description,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
