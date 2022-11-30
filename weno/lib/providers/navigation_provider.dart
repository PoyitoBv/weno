import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart' show CarouselController;

class NavigationProvider extends ChangeNotifier {
  // Principales
  bool _splashScreen = true;
  int currentPage = 0;

  bool get splashScreen => _splashScreen;

  set spashScreen(bool i) {
    _splashScreen = i;
    notifyListeners();
  }

  // Siguintes animaciones despues de la transicion
  bool? _nextAnimations = false;
  bool? get nextAnimations => _nextAnimations;
  set nextAnimations(bool? i) {
    _nextAnimations = i;
    if (_nextAnimations == true) notifyListeners();
  }

  // Redondear las esquinas al hacer Navigation.pop()
  bool? _willPop;
  bool? get willPop => _willPop;
  set willPop(bool? i) {
    _willPop = i;
    if (_willPop != null) notifyListeners();
  }

  Alignment? _addCart;
  Alignment? get addCart => _addCart;
  set addCart(Alignment? i) {
    _addCart = i;
    if (_addCart != null) notifyListeners();
  }

  //* ========== HomePage
  int _currentCard = 0;
  String _chipActive = 'Tradicionales';
  final CarouselController controller = CarouselController();

  int get currentCard => _currentCard;
  String get chipActive => _chipActive;

  set currentCard(int i) {
    // if (_toPage != null && i != _toPage) return;
    // _toPage = null;

    _currentCard = i;

    switch (i) {
      case 0:
        _chipActive = 'Tradicionales';
        break;
      case 1:
        _chipActive = 'Tradicionales';
        break;
      case 2:
        _chipActive = 'Especiales';
        break;
      case 3:
        _chipActive = 'Especiales';
        break;
      case 4:
        _chipActive = 'Explora';
        break;
      default:
        _chipActive = 'Tradicionales';
        break;
    }

    notifyListeners();
  }

  set chipActive(String i) {
    // _chipActive = i;

    if (i == 'Tradicionales' && (_currentCard != 0 || _currentCard != 1)) {
      controller.animateToPage(0,
          curve: Curves.decelerate, duration: const Duration(seconds: 1));
      // _toPage = 0;
    } else if (i == 'Especiales' && (_currentCard != 2 || _currentCard != 3)) {
      controller.animateToPage(2,
          curve: Curves.decelerate, duration: const Duration(seconds: 1));
      // _toPage = 2;
    } else if (i == 'Explora' && (_currentCard != 4)) {
      controller.animateToPage(4,
          curve: Curves.decelerate, duration: const Duration(seconds: 1));
      // _toPage = 4;
    }

    notifyListeners();
  }
}
