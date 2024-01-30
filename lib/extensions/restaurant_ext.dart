import 'package:atta/entities/restaurant.dart';
import 'package:atta/main.dart';
import 'package:collection/collection.dart';

extension AttaRestaurantListExt on List<AttaRestaurant> {
  List<AttaRestaurant> getMostRecent(int maxNumber) {
    return sorted((a, b) => b.createdAt.compareTo(a.createdAt)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getCheaper(int maxNumber) {
    return sorted((a, b) => a.averagePrice.compareTo(b.averagePrice)).take(maxNumber).toList();
  }

  List<AttaRestaurant> getMoreExpensive(int maxNumber) {
    return sorted((a, b) => b.averagePrice.compareTo(a.averagePrice)).take(maxNumber).toList();
  }

  Future<List<AttaRestaurant>> getMostPopular(int maxNumber) async {
    final rawPopularRestaurantIds = await databaseService.getAllRestaurantIdFromReservations();
    final popularRestaurantIds = rawPopularRestaurantIds.groupFoldBy<int, int>(
      (r) => int.parse(r['restaurant_id'].toString()),
      (previous, e) => (previous ?? 0) + 1,
    );
    return sorted((a, b) {
      if (popularRestaurantIds[a.id] == null) return 1;
      if (popularRestaurantIds[b.id] == null) return -1;
      return popularRestaurantIds[b.id]!.compareTo(popularRestaurantIds[a.id]!);
    }).take(maxNumber).toList();
  }
}
