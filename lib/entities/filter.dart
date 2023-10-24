enum AttaFilter {
  fastFood._('Fast Food'),
  pizza._('Pizza'),
  sushi._('Sushi'),
  burger._('Burger'),
  kebab._('Kebab'),
  salad._('Salad'),
  dessert._('Dessert'),
  vegan._('Vegan');

  const AttaFilter._(this.name);

  final String name;
}
