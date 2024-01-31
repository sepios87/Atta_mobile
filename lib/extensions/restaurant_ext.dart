import 'package:atta/entities/restaurant.dart';
import 'package:collection/collection.dart';

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

  List<AttaRestaurant> mostRecentsAndPopulars(int maxNumber) {
    return where((e) => e.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .sorted((a, b) => b.numberOfReservations.compareTo(a.numberOfReservations))
        .take(maxNumber)
        .toList();
  }

  List<AttaRestaurant> withMostDishs(int maxNumber) {
    return sorted((a, b) => b.dishs.length.compareTo(a.dishs.length)).take(maxNumber).toList();
  }
}
