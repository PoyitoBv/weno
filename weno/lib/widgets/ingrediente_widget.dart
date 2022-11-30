import 'package:flutter/material.dart';

import 'package:weno/models/_models.dart';
import 'package:weno/themes/app_theme.dart';

class IngredienteCard extends StatelessWidget {
  final Ingrediente ingrediente;

  const IngredienteCard(this.ingrediente, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image(image: AssetImage(ingrediente.image)),
          ),
          const SizedBox(height: 5),
          Text(ingrediente.name),
          const SizedBox(height: 10),
          Visibility(
            visible: ingrediente.active,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: AppTheme.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
