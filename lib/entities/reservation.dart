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

  factory AttaReservation.fromDateTime({
    required int restaurantId,
    required DateTime dateTime,
    Map<AttaDish, int>? dishs,
  }) {
    return AttaReservation._(
      id: null,
      createdAt: DateTime.now(),
      dateTime: dateTime,
      restaurantId: restaurantId,
      tableId: null,
      numberOfPersons: 2,
      dishs: dishs,
      comment: null,
    );
  }

  factory AttaReservation.fromDishs({
    required int restaurantId,
    Map<AttaDish, int>? dishs,
  }) {
    return AttaReservation._(
      id: null,
      createdAt: DateTime.now(),
      dateTime: DateTime.now(),
      restaurantId: restaurantId,
      tableId: null,
      numberOfPersons: 2,
      dishs: dishs,
      comment: null,
    );
  }

  factory AttaReservation.fromDataForDb({
    required int restaurantId,
    required DateTime dateTime,
    required int numberOfPersons,
    Map<AttaDish, int>? dishs,
    String? comment,
  }) {
    return AttaReservation._(
      id: null,
      createdAt: DateTime.now(),
      dateTime: dateTime,
      restaurantId: restaurantId,
      tableId: null,
      numberOfPersons: numberOfPersons,
      dishs: dishs,
      comment: comment,
    );
  }

  factory AttaReservation.fromMap(Map<String, dynamic> map) {
    print('AttaReservation.fromMap: $map');
    return AttaReservation._(
      id: map.parse<int>('id'),
      createdAt: DateTime.tryParse(map.parse<String>('created_at')) ?? DateTime.now(),
      dateTime: DateTime.tryParse(map.parse<String>('date_time')) ?? DateTime.now(),
      restaurantId: map.parse<int>('restaurant_id'),
      // TODO(florian): mettre de vrais valeurs
      tableId: map.parse<int>('id') == 2 ? null : 0,
      // map['table_id'] as String?,
      numberOfPersons: map.parse<int>('number_of_persons'),
      // Pour savoir d'ou viennent les plat, aller directement dans reservation.restaurant_id et choper les plats
      dishs: null,
      comment: map.parse<String?>('comment'),
    );
  }

  final int? id;
  final DateTime createdAt;
  final DateTime dateTime;
  final int restaurantId;
  final int? tableId;
  final int numberOfPersons;
  final Map<AttaDish, int>? dishs;
  final String? comment;

  bool get withMoreInformations =>
      (comment != null && comment!.isNotEmpty) || (dishs != null && dishs!.isNotEmpty) || tableId != null;

  num get totalAmount => dishs?.entries.fold(0, (p, e) => (p ?? 0) + e.key.price * e.value) ?? 0;

  Map<String, dynamic> toMap() {
    final dbMap = toMapForDb();
    dbMap['id'] = id;
    dbMap['dishs'] = dishs?.keys.map((e) => e.toMap()).toList();
    return dbMap;
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'created_at': createdAt.toIso8601String(),
      'date_time': dateTime.toIso8601String(),
      'restaurant_id': restaurantId,
      // 'table_id': tableId, // TODO(florian): revenir dessus
      'number_of_persons': numberOfPersons,
      'comment': comment,
    };
  }

  AttaReservation copyWith({
    Map<AttaDish, int>? dishs,
    DateTime? dateTime,
  }) {
    return AttaReservation._(
      id: id,
      createdAt: createdAt,
      dateTime: dateTime ?? this.dateTime,
      restaurantId: restaurantId,
      tableId: tableId,
      numberOfPersons: numberOfPersons,
      dishs: dishs ?? this.dishs,
      comment: comment,
    );
  }

  @override
  String toString() => toMap().toString();
}
