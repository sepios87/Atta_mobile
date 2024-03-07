import 'package:atta/entities/dish.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
  thai,
  brazilian;

  factory AttaRestaurantFilter.fromValue(dynamic value) {
    return AttaRestaurantFilter.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttaRestaurantFilter.french,
    );
  }

  String get translatedName {
    return switch (this) {
      crepe => translate('restaurant_filter_entity.crepe'),
      pizza => translate('restaurant_filter_entity.pizza'),
      burger => translate('restaurant_filter_entity.burger'),
      kebab => translate('restaurant_filter_entity.kebab'),
      salad => translate('restaurant_filter_entity.salad'),
      vegan => translate('restaurant_filter_entity.vegan'),
      vegetarian => translate('restaurant_filter_entity.vegetarian'),
      asian => translate('restaurant_filter_entity.asian'),
      french => translate('restaurant_filter_entity.french'),
      italian => translate('restaurant_filter_entity.italian'),
      mexican => translate('restaurant_filter_entity.mexican'),
      indian => translate('restaurant_filter_entity.indian'),
      thai => translate('restaurant_filter_entity.thai'),
      brazilian => translate('restaurant_filter_entity.brazilian'),
    };
  }
}

enum AttaFormulaType<T extends AttaFormula> {
  dish<AttaDish>(),
  menu<AttaMenu>();

  bool isFormulaSameType(AttaFormula formula) => formula is T;

  String get name {
    return switch (this) {
      dish => translate('formula_type_entity.dish'),
      menu => translate('formula_type_entity.menu'),
    };
  }
}
