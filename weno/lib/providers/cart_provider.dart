import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:rive/rive.dart';

import 'package:weno/models/_models.dart';

class CartProvider extends ChangeNotifier {
  double _creditos = 100.0;
  List<Pizza> pizzas = [];
  final List<Pizza> _pizzasDel = [];
  String? _delete;

  bool? _pagoStatus;
  SMITrigger? _acepted;
  SMITrigger? _rejected;
  bool pop = false;

  String get pago {
    if (_pagoStatus == true) return 'Pago Aceptado';
    if (_pagoStatus == false) return 'Pago Rechazado';

    return 'Procesando Pago...';
  }

  double get creditos => _creditos;
  String? get delete => _delete;

  set creditos(double i) {
    _creditos = i;
    notifyListeners();
  }

  set delete(String? i) {
    _delete = i;
    if (_delete != null) notifyListeners();
  }

  set pagoStatus(bool? i) {
    _pagoStatus = i;

    if (_pagoStatus == true) _acepted?.fire();
    if (_pagoStatus == false) _rejected?.fire();
  }

  pagoVerify() async {
    await Future.delayed(const Duration(seconds: 5));

    if (_creditos >= prices) {
      pagoStatus = true;
      notifyListeners();
    } else {
      pagoStatus = false;
      notifyListeners();
    }
  }

  onRiveInit(Artboard art) {
    final controller = StateMachineController.fromArtboard(
      art,
      'Pago',
      onStateChange: _onStateChange,
    );

    art.addController(controller!);
    _acepted = controller.findInput<bool>('Aceptado') as SMITrigger;
    _rejected = controller.findInput<bool>('Rechazado') as SMITrigger;
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'Flotando') pagoVerify();
    if (stateName == 'Rechazado' || stateName == 'Aceptado') {
      await Future.delayed(const Duration(seconds: 4));

      pop = true;
      notifyListeners();
    }
  }

  double get prices {
    double x = 0;

    if (_pizzasDel.isEmpty) {
      for (Pizza i in pizzas) {
        x += i.price;
      }

      return double.parse(x.toStringAsFixed(2));
    }

    for (Pizza i in pizzas) {
      if (!_pizzasDel.contains(i)) x += i.price;
    }

    return double.parse(x.toStringAsFixed(2));
  }

  void replace(int actual, Pizza nueva) {
    pizzas[actual].size = nueva.size;
    pizzas[actual].revanadas = nueva.revanadas;

    notifyListeners();
  }

  void deleteOne(Pizza pizza) {
    _pizzasDel.add(pizza);

    if (_pizzasDel.length == pizzas.length) {
      pizzas.clear();
      _pizzasDel.clear();
    }
    notifyListeners();
  }

  void fix() {
    if (_pizzasDel.isEmpty && pizzas.isEmpty) return;

    for (Pizza i in _pizzasDel) {
      for (int j = 0; j < pizzas.length; j++) {
        if (pizzas[j] == i) {
          pizzas.remove(i);
          break;
        }
      }
    }

    _pizzasDel.clear();
  }
}
