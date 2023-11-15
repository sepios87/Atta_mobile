enum AttaCategoryFilter {
  fastFood._('Fast Food'),
  pizza._('Pizza'),
  sushi._('Sushi'),
  burger._('Burger'),
  kebab._('Kebab'),
  salad._('Salad'),
  dessert._('Dessert'),
  vegan._('Vegan');

  const AttaCategoryFilter._(this.name);

  final String name;
}

enum AttaFormulaFilter {
  dish._('Plat'),
  menu._('Menu'),
  drink._('Boisson');

  const AttaFormulaFilter._(this.name);

  final String name;
}
