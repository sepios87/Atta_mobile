import 'package:atta/entities/dish.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaReservation {
  AttaReservation._({
    required this.id,
    required this.createdAt,
    required this.dateTime,
    required this.restaurantId,
    required this.tableId,
    required this.numberOfPersons,
    required this.dishs,
    required this.comment,
  });

  factory AttaReservation.fromMap(Map<String, dynamic> map) {
    return AttaReservation._(
      id: map.parse<int>('id'),
      createdAt: DateTime.tryParse(map.parse<String>('created_at')) ?? DateTime.now(),
      dateTime: DateTime.tryParse(map.parse<String>('date_time')) ?? DateTime.now(),
      restaurantId: map.parse<int>('restaurant_id'),
      tableId: map.parse<int>('id') == 2 ? null : 0,
      // map['table_id'] as String?,
      numberOfPersons: map.parse<int>('number_of_persons'),
      dishs: map.parse<int>('id') == 1
          ? [
              AttaDish.fromMap({
                'id': 1,
                'name': 'Pateszycb ezucbze czeubce zcezcu  au fromage',
                'price': 1.0,
              }),
              AttaDish.fromMap({
                'id': 2,
                'name': 'Rviolis',
                'price': 12.0,
              }),
            ]
          : [],
      // (map['dish_ids'] as List<dynamic>).map((e) => e as String).toList(),
      comment: map.parse<String?>('comment'),
    );
  }

  final int id;
  final DateTime createdAt;
  final DateTime dateTime;
  final int restaurantId;
  final int? tableId;
  final int numberOfPersons;
  final List<AttaDish> dishs;
  final String? comment;

  bool get withMoreInformations => (comment != null && comment!.isNotEmpty) || dishs.isNotEmpty || tableId != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'date_time': dateTime.toIso8601String(),
      'restaurant_id': restaurantId,
      'table_id': tableId,
      'number_of_persons': numberOfPersons,
      // 'dish': dishIds,
      'comment': comment,
    };
  }
}
