enum AttaCategoryFilter {
  fastFood._('Fast Food'),
  pizza._('Pizza'),
  burger._('Burger'),
  kebab._('Kebab'),
  salad._('Salad'),
  vegan._('Vegan'),
  vegetarian._('Vegetarian'),
  asian._('Asian'),
  french._('French'),
  italian._('Italian'),
  mexican._('Mexican'),
  indian._('Indian'),
  thai._('Thai');

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
