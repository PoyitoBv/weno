import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:weno/themes/app_theme.dart';
import 'package:weno/providers/_providers.dart';
// import 'package:weno/models/_models.dart';
import '_widgets.dart';

class EditCard extends StatefulWidget {
  final String name, description;

  const EditCard({super.key, required this.name, required this.description});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navProv = Provider.of<NavigationProvider>(context);

    if (navProv.nextAnimations == true) _controller.forward();
    if (navProv.willPop == true) _controller.reverse();

    return Padding(
      padding:
          EdgeInsets.only(left: (MediaQuery.of(context).size.width / 2) - 140),
      child: Stack(
        children: [
          EditCardBackground(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 30),
                  _PizzaInfo(
                      name: widget.name, description: widget.description),
                  const SizedBox(height: 20),
                  const _Ingredientes(),
                ],
              ),
            ),
          ),
          const _Pizza(),
        ],
      ),
    );
  }
}

class _PizzaInfo extends StatelessWidget {
  final String name, description;
  const _PizzaInfo({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    final pizzaProv = Provider.of<PizzaProvider>(context);
    final pizza = pizzaProv.currentPizza!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Row(
                children: ['C', 'M', 'G']
                    .asMap()
                    .entries
                    .map(
                      (e) => GestureDetector(
                        onTap: () => pizzaProv.changeSize = e.key,
                        child: Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: pizza.size != e.key
                                ? AppTheme.whiteLow
                                : AppTheme.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Text(
                            e.value,
                            style: TextStyle(
                              color: pizza.size == e.key
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                          )),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}

class _Ingredientes extends StatelessWidget {
  const _Ingredientes();

  @override
  Widget build(BuildContext context) {
    final pizzaProv = Provider.of<PizzaProvider>(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: 100,
        enlargeCenterPage: true,
        viewportFraction: .26,
      ),
      items: pizzaProv.ingredientes.map((i) {
        return GestureDetector(
          onTap: () => pizzaProv.addOrRest(!i.active, i.name),
          child: IngredienteCard(i),
        );
      }).toList(),
    );
  }
}

class _Pizza extends StatelessWidget {
  const _Pizza();

  @override
  Widget build(BuildContext context) {
    final pizzaProv = Provider.of<PizzaProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: ['entero', 'mitad', 'cuarto']
                .asMap()
                .entries
                .map((i) => GestureDetector(
                      onTap: () => pizzaProv.edicion = i.key,
                      child: Container(
                        height: 35,
                        width: 35,
                        margin: const EdgeInsets.only(bottom: 10, left: 15),
                        // decoration: BoxDecoration(
                        //   color: pizzaProv.edicion == i
                        //       ? AppTheme.black
                        //       : AppTheme.whiteLow,
                        //   shape: BoxShape.circle,
                        // ),
                        child: Image(
                          image: AssetImage('assets/icons/${i.value}.png'),
                          color: pizzaProv.edicion == i.key
                              ? AppTheme.black
                              : AppTheme.whiteLow,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const PizzaAnimation(),
              Column(
                children: [
                  Row(
                    children: [0, 1]
                        .map((i) => GestureDetector(
                              onTap: i == 0
                                  ? pizzaProv.turnLeft
                                  : pizzaProv.turnRight,
                              child: Container(
                                height: 35,
                                width: 35,
                                margin: i == 0
                                    ? const EdgeInsets.only(right: 130)
                                    : null,
                                decoration: const BoxDecoration(
                                    color: AppTheme.whiteLow,
                                    shape: BoxShape.circle),
                                child: Icon(i == 0
                                    ? Icons.arrow_back_ios_new_rounded
                                    : Icons.arrow_forward_ios_rounded),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 55),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
