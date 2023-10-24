import 'package:atta/entities/filter.dart';

class AttaRestaurant {
  const AttaRestaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.filter,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<AttaFilter> filter;
}
