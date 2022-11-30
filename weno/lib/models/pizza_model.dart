import 'dart:math' show Random;

class Pizza {
  Pizza({
    required this.name,
    required this.description,
    this.size = 1,
    this.button = 'Add',
  }) {
    revanadas = [1, 2, 3, 4, 5, 6, 7, 8].map((e) => Revanada()).toList();

    switch (name) {
      case 'Peperoni':
        for (Revanada i in revanadas) {
          i.ingredientes['Peperoni'] = true;
        }
        break;
      case 'Hawaiana':
        for (Revanada i in revanadas) {
          i.ingredientes['Jamón'] = true;
          i.ingredientes['Piña'] = true;
        }
        break;
      case 'Mexicana':
        for (Revanada i in revanadas) {
          i.ingredientes['Cebolla'] = true;
          i.ingredientes['Morron'] = true;
          i.ingredientes['Jalapeño'] = true;
          i.ingredientes['Peperoni'] = true;
        }
        break;
      case 'Mumet':
        for (Revanada i in revanadas) {
          i.ingredientes['Jalapeño'] = true;
          i.ingredientes['Jamón'] = true;
          i.ingredientes['Peperoni'] = true;
          i.ingredientes['Salchicha'] = true;
          i.ingredientes['Tocino'] = true;
        }
        break;
      default:
        image = 'assets/Sorpresa.png';
        break;
    }

    if (image == '') image = 'assets/$name.png';

    id =
        '${Random().nextInt(1000)}#$name#$description#$image#${Random().nextInt(1000)}#${DateTime.now()}';
  }

  String name, description, button;
  int size;
  late List<Revanada> revanadas;
  late String id;
  String image = '';

  double get price {
    double x = 0;

    switch (size) {
      case 0:
        x += 60;
        break;
      case 1:
        x += 70;
        break;
      case 2:
        x += 80;
        break;
      default:
        break;
    }

    for (Revanada i in revanadas) {
      if (i.ingredientes['Aceituna'] == true) x += 1;
      if (i.ingredientes['Cebolla'] == true) x += .7;
      if (i.ingredientes['Champiñon'] == true) x += 1;
      if (i.ingredientes['Jalapeño'] == true) x += .4;
      if (i.ingredientes['Jamón'] == true) x += .6;
      if (i.ingredientes['Morron'] == true) x += 1;
      if (i.ingredientes['Peperoni'] == true) x += 1.2;
      if (i.ingredientes['Piña'] == true) x += .7;
      if (i.ingredientes['Salchicha'] == true) x += .8;
      if (i.ingredientes['Tocino'] == true) x += .9;
    }
    return double.parse(x.toStringAsFixed(2));
  }

  String get getSize {
    switch (size) {
      case 0:
        return 'C';
      case 2:
        return 'G';
      default:
        return 'M';
    }
  }

  List<List<String>> get getIngredientes {
    final List<List<String>> ing = [];

    for (Revanada i in revanadas) {
      final List<String> temp = [];
      // bool igual = true;

      for (String j in i.ingredientes.keys) {
        if (i.ingredientes[j] == true) temp.add(j);
      }

      if (temp.isEmpty) temp.add('Solo queso');

      if (temp.isNotEmpty) if (ing.isEmpty) ing.add(temp);

      if (temp.length != ing[ing.length - 1].length) ing.add(temp);

      for (int i = 0;
          i <
              (temp.length > ing[ing.length - 1].length
                  ? temp.length
                  : ing[ing.length - 1].length);
          i++) {
        if (temp[i] != ing[ing.length - 1][i]) {
          ing.add(temp);
          break;
        }
      }
    }

    if (ing.length == 1) return ing;

    if (ing[0].length == ing[ing.length - 1].length) {
      bool igual = true;
      for (int i = 0;
          i <
              (ing[0].length > ing[ing.length - 1].length
                  ? ing[0].length
                  : ing[ing.length - 1].length);
          i++) {
        if (ing[0][i] != ing[ing.length - 1][i]) {
          igual = false;
          break;
        }
      }

      if (igual) ing.removeLast();
    }

    return ing;
  }
}

class Revanada {
  Map<String, bool> ingredientes = {
    'Aceituna': false,
    'Cebolla': false,
    'Champiñon': false,
    'Jalapeño': false,
    'Jamón': false,
    'Morron': false,
    'Peperoni': false,
    'Piña': false,
    'Salchicha': false,
    'Tocino': false,
  };
}

class Ingrediente {
  Ingrediente({required this.name, this.image = ''});

  String name, image;
  bool active = false;
}
