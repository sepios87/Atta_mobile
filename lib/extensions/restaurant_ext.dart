import 'package:atta/entities/restaurant.dart';
import 'package:collection/collection.dart';

extension AttaRestaurantExt on AttaRestaurant {
  String shareText() {
    // TODO(florian): translate
    return "Découvre le restaurant $name, à l'adresse suivante : $address";
  }
}

extension AttaRestaurantListExt on List<AttaRestaurant> {
  List<AttaRestaurant> getMostRecents(int maxNumber) {
    return sorted((a, b) => b.createdAt.compareTo(a.createdAt)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getCheapers(int maxNumber) {
    return sorted((a, b) => a.averagePrice.compareTo(b.averagePrice)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getMostExpensives(int maxNumber) {
    return sorted((a, b) => b.averagePrice.compareTo(a.averagePrice)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getMostPopulars(int maxNumber) {
    return sorted((a, b) => b.numberOfReservations.compareTo(a.numberOfReservations)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getBiggestNumberFormula(int maxNumber) {
    return sorted((a, b) {
      final aNumberOfFormula = a.menus.length + a.dishes.length;
      final bNumberOfFormula = b.menus.length + b.dishes.length;
      return bNumberOfFormula.compareTo(aNumberOfFormula);
    }).take(maxNumber).toList();
  }

  List<AttaRestaurant> mostRecentsAndPopulars(int maxNumber) {
    return where((e) => e.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .sorted((a, b) => b.numberOfReservations.compareTo(a.numberOfReservations))
        .take(maxNumber)
        .toList();
  }

  List<AttaRestaurant> withMostDishes(int maxNumber) {
    return sorted((a, b) => b.dishes.length.compareTo(a.dishes.length)).take(maxNumber).toList();
  }

  List<AttaRestaurant> withCheaperMenu(int maxNumber) {
    return sorted((a, b) {
      a.menus.sort((a, b) => a.price.compareTo(b.price));
      b.menus.sort((a, b) => a.price.compareTo(b.price));
      if (a.menus.isEmpty) return 1;
      if (b.menus.isEmpty) return -1;
      return a.menus.first.price.compareTo(b.menus.first.price);
    }).take(maxNumber).toList();
  }
}
