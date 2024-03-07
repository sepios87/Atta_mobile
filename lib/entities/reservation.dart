import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/map_ext.dart';
import 'package:flutter/material.dart';

@immutable
class AttaMenuReservation {
  const AttaMenuReservation._({
    required this.id,
    required this.menuId,
    required this.selectedDishIds,
  });

  factory AttaMenuReservation.fromMap(Map<String, dynamic> map) {
    return AttaMenuReservation._(
      id: map.parse<int?>('id'),
      menuId: map.parse<int>('menu_id'),
      selectedDishIds: map.parse<List>('selected_dishes_ids_list').map((e) => int.parse(e.toString())).toSet(),
    );
  }

  factory AttaMenuReservation.fromValues({
    required int menuId,
    required Set<int> selectedDishIds,
  }) {
    return AttaMenuReservation._(
      id: null,
      menuId: menuId,
      selectedDishIds: selectedDishIds,
    );
  }

  final int? id;
  final int menuId;
  final Set<int> selectedDishIds;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'menu_id': menuId,
      'selected_dishes_ids_list': selectedDishIds,
    };
  }

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final sameId = other is AttaMenuReservation && other.id == id;
    final sameMenuId = other is AttaMenuReservation && other.menuId == menuId;
    final sameSelectedDishIds = other is AttaMenuReservation && other.selectedDishIds == selectedDishIds;
    return sameId && sameMenuId && sameSelectedDishIds;
  }

  @override
  int get hashCode => menuId.hashCode;
}

class AttaReservation {
  AttaReservation._({
    required this.id,
    required this.createdAt,
    required this.dateTime,
    required this.restaurantId,
    required this.tableId,
    required this.numberOfPersons,
    required this.dishIds,
    required this.menus,
    required this.comment,
  });

  factory AttaReservation.fromRestaurantId({
    required int restaurantId,
  }) {
    return AttaReservation._(
      id: null,
      createdAt: DateTime.now(),
      dateTime: DateTime.now(),
      restaurantId: restaurantId,
      tableId: null,
      numberOfPersons: 2,
      dishIds: {},
      menus: {},
      comment: null,
    );
  }

  factory AttaReservation.fromMap(Map<String, dynamic> map) {
    return AttaReservation._(
      id: map.parse<int>('id'),
      createdAt: DateTime.tryParse(map.parse<String>('created_at')) ?? DateTime.now(),
      dateTime: DateTime.tryParse(map.parse<String>('date_time')) ?? DateTime.now(),
      restaurantId: map.parse<int>('restaurant_id'),
      // TODO(florian): mettre de vrais valeurs
      tableId: map.parse<int>('id') == 2 ? null : 0,
      // map['table_id'] as String?,
      numberOfPersons: map.parse<int>('number_of_persons'),
      dishIds: Map.fromEntries(
        map.parse<List>('dish_reservation', fallback: []).map((d) {
          final dishReservationMap = d as Map<String, dynamic>;
          final dishId = dishReservationMap['dish_id'] as int;
          final quantity = dishReservationMap['quantity'] as int;
          return MapEntry(dishId, quantity);
        }),
      ),
      menus: map
          .parse<List>('menu_reservation', fallback: [])
          .map((m) => AttaMenuReservation.fromMap(m as Map<String, dynamic>))
          .toSet(),
      comment: map.parse<String?>('comment'),
    );
  }

  final int? id;
  final DateTime createdAt;
  final DateTime dateTime;
  final int restaurantId;
  final int? tableId;
  final int numberOfPersons;
  final Map<int, int> dishIds;
  final Set<AttaMenuReservation> menus;
  final String? comment;

  bool get withFormulas => menus.isNotEmpty || dishIds.isNotEmpty;

  bool get withMoreInformations => (comment != null && comment!.isNotEmpty) || dishIds.isNotEmpty || tableId != null;

  Map<String, dynamic> toMap() {
    final dbMap = toMapForDb();
    dbMap['id'] = id;
    dbMap['dish_reservation'] = dishIds.entries.map((e) => {'dish_id': e.key, 'quantity': e.value});
    dbMap['menu_reservation'] = menus.map((m) => m.toMap());
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
    int? restaurantId,
    Map<int, int>? dishIds,
    Set<AttaMenuReservation>? menus,
    DateTime? dateTime,
    int? numberOfPersons,
    Wrapped<int?>? tableId,
    String? comment,
  }) {
    return AttaReservation._(
      id: id,
      createdAt: createdAt,
      dateTime: dateTime ?? this.dateTime,
      restaurantId: restaurantId ?? this.restaurantId,
      tableId: tableId == null ? this.tableId : tableId.value,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      dishIds: dishIds ?? this.dishIds,
      menus: menus ?? this.menus,
      comment: comment,
    );
  }

  @override
  String toString() => toMap().toString();
}
