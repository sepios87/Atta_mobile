import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_time.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:flutter/material.dart';

final mockedData = List.filled(
  10,
  AttaRestaurant(
    id: 'id',
    name: 'Papa burger',
    imageUrl: 'https://picsum.photos/200/300',
    category: [AttaFilter.burger],
    address: '6 Rue Charles Michels, Limoges',
    description:
        'Le papaburger est un restaurant de burger végétarien. Nous proposons des burgers de qualité avec des produits frais et locaux.',
    email: 'resto@gmail.com',
    phone: '0123456789',
    website: 'https://google.com',
    openingTimes: {
      AttaDay.tuesday: const [
        AttaOpeningTime(
          open: TimeOfDay(hour: 12, minute: 0),
          close: TimeOfDay(hour: 14, minute: 0),
        ),
        AttaOpeningTime(
          open: TimeOfDay(hour: 18, minute: 0),
          close: TimeOfDay(hour: 22, minute: 0),
        ),
      ],
    },
    dishes: List.filled(
      10,
      AttaDish(
        id: '1',
        name: 'Burger',
        imageUrl: 'https://picsum.photos/200/300',
        description: 'Un bon burger végétarien a manger sur place ou a emporter avec de la sauce kebab',
        price: 12,
        ingredients: ['pain', 'viande', 'salade', 'tomate'],
      ),
    ),
    menus: [
      AttaMenu(
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
