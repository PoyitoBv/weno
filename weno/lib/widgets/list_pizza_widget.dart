import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:weno/models/_models.dart';

// import 'package:weno/themes/app_theme.dart';
import '../providers/_providers.dart';
import '_widgets.dart';

class ListPizza extends StatelessWidget {
  const ListPizza({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatonProvider = Provider.of<NavigationProvider>(context);

    final List<Pizza> pizzas = [
      Pizza(name: 'Hawaiana', description: 'Pizza con piña para la niña.'),
      Pizza(name: 'Peperoni', description: 'La tradicional de Peperoni.'),
      Pizza(name: 'Mexicana', description: 'El sabor de nuestra tierra.'),
      Pizza(name: 'Mumet', description: 'Especialmete deliciosa.'),
      Pizza(
          name: 'Crea',
          description: 'Algo nuevo, único y a tu gusto.',
          button: 'New'),
    ];

    return CarouselSlider(
      carouselController: navigatonProvider.controller,
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height * .6,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          viewportFraction: .7,
          onPageChanged: (i, _) {
            navigatonProvider.currentCard = i;
          }),
      items: pizzas.map((i) {
        return PizzaCard(i);
      }).toList(),
    );
  }
}

//* 490 .7
