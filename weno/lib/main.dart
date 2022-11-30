import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:weno/themes/app_theme.dart';
import 'package:weno/providers/_providers.dart';

import 'pages/_pages.dart';
// import 'package:weno/pages/prueba.dart';

///! Errores
///! Al hacer al [Pop()] despues de hacer la compra, no se puede volver a hacer
///! El carrito no hace nada cuando se añade algo

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PizzaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weno',
        theme: AppTheme.theme,
        home: const SplashScreen(),
        routes: {
          'pago': (_) => const PagoPage(),
        },
      ),
    );
  }
}
