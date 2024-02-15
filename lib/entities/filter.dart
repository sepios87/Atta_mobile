import 'package:atta/entities/dish.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';

enum AttaRestaurantFilter {
  crepe,
  vegetarian,
  pizza,
  burger,
  kebab,
  salad,
  vegan,
  asian,
  french,
  italian,
  mexican,
  indian,
  thai;

  factory AttaRestaurantFilter.fromValue(dynamic value) {
    return AttaRestaurantFilter.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttaRestaurantFilter.french,
    );
  }

  String get translatedName {
    return switch (this) {
      crepe => 'Crêpe',
      pizza => 'Pizza',
      burger => 'Burger',
      kebab => 'Kebab',
      salad => 'Salad',
      vegan => 'Vegan',
      vegetarian => 'Végétarien',
      asian => 'Asiatique',
      french => 'Francais',
      italian => 'Italien',
      mexican => 'Mexicain',
      indian => 'Indien',
      thai => 'Thai',
    };
  }
}

enum AttaFormulaType<T extends AttaFormula> {
  dish<AttaDish>(),
  menu<AttaMenu>();

  bool isFormulaSameType(AttaFormula formula) => formula is T;

  String get name {
    return switch (this) {
      dish => 'Plat',
      menu => 'Menu',
    };
  }
}
