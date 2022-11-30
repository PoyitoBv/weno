import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/_providers.dart';
import '../themes/app_theme.dart';
import '../models/_models.dart';
import '../pages/_pages.dart';
import '../widgets/_widgets.dart';
import '../transitions/_transitions.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;

  const PizzaCard(this.pizza, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 430,
      width: 270,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 15, right: 15),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: () {
              final pizzaProv =
                  Provider.of<PizzaProvider>(context, listen: false);

              pizzaProv.delete();

              pizzaProv.currentPizza = Pizza(
                name: pizza.name,
                description: pizza.description,
              );

              Navigator.of(context).push(
                MyCustomAnimatedRoute(
                  enterWidget: const TransitionPage(EditPage()),
                  alignment: const Alignment(0, 0),
                ),
              );
            },
            child: _Contenido(pizza: pizza),
          ),
          // Botón
          _Boton(pizza: pizza),
        ],
      ),
    );
  }
}

class _Boton extends StatelessWidget {
  const _Boton({
    Key? key,
    required this.pizza,
  }) : super(key: key);

  final Pizza pizza;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AddButton(
          pizza.button,
          onTap: pizza.button == 'New'
              ? () {
                  final pizzaProv =
                      Provider.of<PizzaProvider>(context, listen: false);

                  pizzaProv.delete();

                  pizzaProv.currentPizza = Pizza(
                    name: pizza.name,
                    description: pizza.description,
                  );

                  Navigator.of(context).push(
                    MyCustomAnimatedRoute(
                      enterWidget: const TransitionPage(EditPage()),
                      alignment: const Alignment(0, 0),
                    ),
                  );
                }
              : () {
                  final cartProv =
                      Provider.of<CartProvider>(context, listen: false);

                  cartProv.pizzas.add(Pizza(
                    name: pizza.name,
                    description: pizza.description,
                  ));
                },
        ),
      ],
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    Key? key,
    required this.pizza,
  }) : super(key: key);

  final Pizza pizza;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            pizza.name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          //todo:  Agregar imagen
          SizedBox(
            height: MediaQuery.of(context).size.height * .27,
            child: Image(image: AssetImage(pizza.image)),
          ),
          //
          Text(
            '\$${pizza.price}',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          Text(
            pizza.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
