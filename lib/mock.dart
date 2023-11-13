import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:flutter/material.dart';

final mockedData = List.filled(
  10,
  AttaRestaurant(
    id: 'id',
    name: 'Papa burger',
    imageUrl: 'https://picsum.photos/200/300',
    filter: [AttaFilter.burger],
    address: '12 rue du bourg',
    description: 'lorem ipsum dolor sit amet',
    email: 'resto@gmail.com',
    phone: '0123456789',
    website: 'https://google.com',
    openingTimes: {
      Day.monday: const [
        OpeningTime(
          open: TimeOfDay(hour: 12, minute: 0),
          close: TimeOfDay(hour: 14, minute: 0),
        ),
        OpeningTime(
          open: TimeOfDay(hour: 18, minute: 0),
          close: TimeOfDay(hour: 22, minute: 0),
        ),
      ],
    },
    dishes: List.filled(
      10,
      Dish(
        id: '1',
        name: 'Burger',
        imageUrl: 'https://picsum.photos/200/300',
        description: 'Un bon burger végétarien a manger sur place ou a emporter avec de la sauce kebab',
        price: 12,
        ingredients: ['pain', 'viande', 'salade', 'tomate'],
      ),
    ),
    menus: [
      Menu(
        id: '1',
        name: 'Menu',
        imageUrl: 'https://picsum.photos/200/300',
        description: 'lorem ipsum dolor sit amet',
        price: 12,
        dishIds: ['1'],
      ),
    ],
  ),
);
