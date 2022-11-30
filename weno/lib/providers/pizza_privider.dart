import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:rive/rive.dart';

import 'package:weno/models/_models.dart';

class PizzaProvider extends ChangeNotifier {
  Pizza? _currentPizza;
  int _edicion = 0;
  List<int> _currentRevs = [0, 1, 2, 3, 4, 5, 6, 7];
  final List<Ingrediente> _ingredientes = [
    Ingrediente(name: 'Aceituna', image: 'assets/icons/ace.png'),
    Ingrediente(name: 'Cebolla', image: 'assets/icons/ceb.png'),
    Ingrediente(name: 'Champiñon', image: 'assets/icons/cha.png'),
    Ingrediente(name: 'Jalapeño', image: 'assets/icons/jal.png'),
    Ingrediente(name: 'Jamón', image: 'assets/icons/jam.png'),
    Ingrediente(name: 'Morron', image: 'assets/icons/mor.png'),
    Ingrediente(name: 'Peperoni', image: 'assets/icons/pep.png'),
    Ingrediente(name: 'Piña', image: 'assets/icons/pin.png'),
    Ingrediente(name: 'Salchicha', image: 'assets/icons/sal.png'),
    Ingrediente(name: 'Tocino', image: 'assets/icons/toc.png'),
  ];

  //* Controladores de la animacion
  SMIInput? _edicionSM;
  SMITrigger? _turnRightSM;
  SMITrigger? _turnLeftSM;
  List<SMIInput<bool>>? _currentRevsSM;
  List<SMIInput<bool>>? _ingredientesSM;
  final Map<String, SMITrigger?> _ingredientesActionSM = {
    'Aceituna': null,
    'Cebolla': null,
    'Champiñon': null,
    'Jalapeño': null,
    'Jamón': null,
    'Morron': null,
    'Peperoni': null,
    'Piña': null,
    'Salchicha': null,
    'Tocino': null,
  };
  //* =============

  Pizza? get currentPizza => _currentPizza;
  int get edicion => _edicion;

  List<Ingrediente> get ingredientes {
    for (int i = 0; i < _ingredientes.length; i++) {
      _ingredientes[i].active = false;

      _ingredientesSM?[i].value = !_ingredientes[i].active;
    }

    for (int i in _currentRevs) {
      for (int j = 0; j < _ingredientes.length; j++) {
        if (_currentPizza!.revanadas[i].ingredientes[_ingredientes[j].name] ==
            true) {
          _ingredientes[j].active = true;

          _ingredientesSM?[j].value = !_ingredientes[j].active;
        }
      }
    }

    return _ingredientes;
  }

  set currentPizza(Pizza? i) {
    _currentPizza = i;

    if (_currentPizza != null) notifyListeners();
  }

  set changeSize(int i) {
    if (_currentPizza == null || i == _currentPizza!.size) return;

    _currentPizza!.size = i;

    notifyListeners();
  }

  set edicion(int i) {
    if (_currentPizza == null) return;

    switch (i) {
      case 1:
        if (_edicion == 2 && _currentRevs[0] == 5) {
          _currentRevs = [4, 5, 6, 7];
          break;
        }

        _currentRevs = [0, 1, 2, 3];
        break;
      case 2:
        if (_edicion == 1 && _currentRevs[0] == 4) {
          _currentRevs = [5, 6];
          break;
        }

        _currentRevs = [1, 2];
        break;
      default:
        _currentRevs = [0, 1, 2, 3, 4, 5, 6, 7];
        break;
    }

    _edicion = i;
    _edicionSM?.value = _edicion.toDouble();

    notifyListeners();
  }

  void turnRight() {
    if (_currentPizza == null) return;

    switch (_edicion) {
      case 1:
        if (_currentRevs[0] == 0) {
          _currentRevs = [4, 5, 6, 7];
          break;
        }
        if (_currentRevs[0] == 4) _currentRevs = [0, 1, 2, 3];
        break;
      case 2:
        _currentRevs[0] += 2;
        _currentRevs[1] += 2;

        if (_currentRevs[0] == 7) _currentRevs = [7, 0];
        if (_currentRevs[0] == 9) _currentRevs = [1, 2];

        break;
      default:
        break;
    }

    _turnRightSM?.fire();
    notifyListeners();
  }

  void turnLeft() {
    if (_currentPizza == null) return;

    switch (_edicion) {
      case 1:
        if (_currentRevs[0] == 0) {
          _currentRevs = [4, 5, 6, 7];
          break;
        }
        if (_currentRevs[0] == 4) _currentRevs = [0, 1, 2, 3];
        break;
      case 2:
        _currentRevs[0] -= 2;
        _currentRevs[1] -= 2;

        if (_currentRevs[0] == -1) _currentRevs = [7, 0];
        if (_currentRevs[1] == -2) _currentRevs = [5, 6];

        break;
      default:
        break;
    }

    _turnLeftSM?.fire();
    notifyListeners();
  }

  void addOrRest(bool i, String name) async {
    if (_currentPizza == null) return;
    // si voy a recibir lo contrario de lo que esté seleccionado == al estado al que va a cambiar

    List<int> temp = [];

    if (!i) {
      for (int x in _currentRevs) {
        if (_currentPizza!.revanadas[x].ingredientes[name] == true) temp.add(x);
      }
    } else {
      temp.addAll(_currentRevs);
    }

    for (int x in _currentRevsSM!.asMap().keys) {
      _currentRevsSM?[x].value = temp.contains(x) ? true : false;
      // log('Valor ${_currentRevsSM?[x].value}');
    }

    await Future.delayed(const Duration(milliseconds: 200));
    //! El problema parece ser que el paquete hace más rapido el [fire()] que el cambiar un <bool>

    for (int x in temp) {
      _ingredientesActionSM[name]?.fire();

      _currentPizza!.revanadas[x].ingredientes[name] = i;
    }

    notifyListeners();
  }

  // Dispose
  void delete() {
    _edicion = 0;
    _currentRevs = [0, 1, 2, 3, 4, 5, 6, 7];
    _currentPizza = null;
  }

  void onRiveInit(Artboard art) {
    final controller = StateMachineController.fromArtboard(
      art,
      'App',
      // onStateChange: _onStateChange,
    );
    art.addController(controller!);
    _turnRightSM = controller.findInput<bool>('Adelante') as SMITrigger;
    _turnLeftSM = controller.findInput<bool>('Atras') as SMITrigger;
    _edicionSM = controller.findInput<double>('Edicion') as SMINumber;

    _currentRevsSM = _currentRevs
        .map((e) => controller.findInput<bool>('Reb$e') as SMIBool)
        .toList();
    _ingredientesSM = _ingredientes
        .map((e) => controller.findInput<bool>('${e.name}Stat') as SMIBool)
        .toList();
    _ingredientesActionSM.forEach((i, _) => _ingredientesActionSM[i] =
        controller.findInput<bool>(i) as SMITrigger?);

    _initIngredientes();
  }

  void _initIngredientes() async {
    for (int x in _currentRevsSM!.asMap().keys) {
      _currentRevsSM?[x].value = true;
    }

    await Future.delayed(const Duration(milliseconds: 10));

    //! Tengo que quitar todos los [delayed()] de 400s de abajo
    /// Esto es ocacionado porque en la logica de la animación, le indiqué que
    /// antes de salirse del estado en el que está animando la {entrada o
    /// salida} de algún ingrediente, tiene que esperar como 200 o 300 ms,
    /// esto lo podría quitar, solo sería necesario revisar si no traería con
    /// el algúnos errores, en principio no.

    switch (_currentPizza?.name) {
      case 'Peperoni':
        _ingredientesActionSM['Peperoni']?.fire();
        break;

      case 'Hawaiana':
        _ingredientesActionSM['Piña']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Jamón']?.fire();
        break;

      case 'Mexicana':
        _ingredientesActionSM['Peperoni']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Cebolla']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Morron']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Jalapeño']?.fire();
        break;

      case 'Mumet':
        _ingredientesActionSM['Jalapeño']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Jamón']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Peperoni']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Salchicha']?.fire();
        await Future.delayed(const Duration(milliseconds: 250));
        _ingredientesActionSM['Tocino']?.fire();
        break;

      default:
        break;
    }
  }

  //* Saber en que animación está en la maquina de estado
  // void _onStateChange(
  //   String stateMachineName,
  //   String stateName,
  // ) =>
  //     log('State Changed in $stateMachineName to $stateName');
}
