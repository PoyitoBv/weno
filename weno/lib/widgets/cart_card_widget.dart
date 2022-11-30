import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../transitions/_transitions.dart';
import '../pages/_pages.dart';
import '../providers/_providers.dart';
import '../themes/app_theme.dart';
import '../models/_models.dart';

class CartCard extends StatefulWidget {
  final Pizza pizza;

  const CartCard(this.pizza, {super.key});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> with TickerProviderStateMixin {
  //* Animacion de expandir la tarjeta
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  );

  //* Animacion de Encojer
  late final AnimationController _controllerDelete = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    value: 1,
  );
  late final Animation<double> _animationDelete = CurvedAnimation(
      parent: _controllerDelete, curve: Curves.fastLinearToSlowEaseIn)
    ..addStatusListener((status) => _delete(status));

  //* Animacion de perder tamaño para que las demas suban
  late final AnimationController _controllerDeletePost = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 1,
  );
  late final Animation<double> _animationDeletePost =
      CurvedAnimation(parent: _controllerDeletePost, curve: Curves.decelerate);

  bool _isExpanded = false;

  void _delete(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) return;

    _controllerDeletePost.reverse();

    final cartProv = Provider.of<CartProvider>(context, listen: false);

    cartProv.delete = null;
    cartProv.deleteOne(widget.pizza);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerDelete.dispose();
    _controllerDeletePost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    if (cartProv.delete == widget.pizza.id) _controllerDelete.reverse();

    return SizeTransition(
      sizeFactor: _animationDeletePost,
      child: ScaleTransition(
        scale: _animationDelete,
        child: Center(
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: AppTheme.yellow,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _expand,
                  child: _Header(widget.pizza),
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: Column(
                    children: [
                      const Divider(color: AppTheme.white, height: 40),
                      _Body(widget.pizza),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _expand() {
    if (!_isExpanded) {
      _controller.forward();
      _isExpanded = !_isExpanded;
      return;
    }

    _controller.reverse();
    _isExpanded = !_isExpanded;
  }
}

class _Header extends StatelessWidget {
  final Pizza pizza;

  const _Header(this.pizza);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: AppTheme.whiteLow,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  pizza.getSize,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(pizza.name,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '\$${pizza.price}',
              style: TextStyle(
                color: AppTheme.black.withOpacity(.5),
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 30),
            const Icon(
              Icons.arrow_drop_down,
              color: AppTheme.white,
              size: 30,
            ),
          ],
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final Pizza pizza;

  const _Body(this.pizza);

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    // Text(e[0], style: style),
    final List<Widget> body = pizza.getIngredientes
        .map<Widget>((e) => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: 15,
                  margin: const EdgeInsets.only(right: 10, top: 5),
                  decoration: const BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      e.map<Widget>((i) => Text(i, style: style)).toList(),
                )
              ],
            ))
        .toList();

    body.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            final pizzaProv =
                Provider.of<PizzaProvider>(context, listen: false);

            pizzaProv.delete();

            pizzaProv.currentPizza = Pizza(
              name: pizza.name,
              description: pizza.description,
              size: pizza.size,
              button: 'Save',
            );

            // Esto es porque no podía pasar la lista de Revanadas, la
            // revanada, ni el mapa de ingredientes. A lo que tengo entendido
            // es porque en dart las variables se pasan por referencia, eso
            // o estoy muy meco.
            for (int i = 0; i < 8; i++) {
              for (String j in pizza.revanadas[i].ingredientes.keys) {
                pizzaProv.currentPizza!.revanadas[i].ingredientes[j] =
                    pizza.revanadas[i].ingredientes[j]!;
              }
            }

            pizzaProv.currentPizza!.id = pizza.id;

            Navigator.of(context).push(
              MyCustomAnimatedRoute(
                enterWidget: const TransitionPage(EditPage()),
                alignment: const Alignment(0, 0),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 30),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppTheme.whiteLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: AppTheme.black),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            final cartProv = Provider.of<CartProvider>(context, listen: false);

            cartProv.delete = pizza.id;
          },
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                // color: AppTheme.whiteLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restore_from_trash_rounded,
                  color: AppTheme.black)),
        ),
      ],
    ));

    return Wrap(spacing: 20, runSpacing: 10, children: body);
  }
}

// class _Pizza extends StatelessWidget {
//   const _Pizza();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       width: 150,
//       decoration: BoxDecoration(
//         color: Colors.green[100],
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
