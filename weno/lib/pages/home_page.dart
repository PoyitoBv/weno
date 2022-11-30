import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../transitions/_transitions.dart';
import '../models/_models.dart';
import '../pages/_pages.dart';
import '../providers/_providers.dart';
import '../themes/app_theme.dart';
import 'package:weno/widgets/_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.yellow,
        body: SafeArea(
          // bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  const MyAppBar(),
                  const ChipButtons(),
                  const ListPizza(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1, 2, 3, 4]
                        .asMap()
                        .entries
                        .map((e) => Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                      navigationProvider.currentCard == e.key
                                          ? 0.9
                                          : 0.4)),
                            ))
                        .toList(),
                  ),
                ],
              ),
              NewButton(() {
                final pizzaProv =
                    Provider.of<PizzaProvider>(context, listen: false);

                pizzaProv.delete();

                pizzaProv.currentPizza = Pizza(
                    name: 'Crea',
                    description: 'Algo nuevo, único y a tu gusto.',
                    button: 'New');

                Navigator.of(context).push(
                  MyCustomAnimatedRoute(
                    enterWidget: const TransitionPage(EditPage()),
                    alignment: const Alignment(0, 0),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
