import 'dart:math';

import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_time.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

final mockedData = generateMockedData();

final Random _random = Random();

List<AttaRestaurant> generateMockedData() {
  final List<AttaRestaurant> mockedData = [];

  for (int i = 0; i < 50; i++) {
    final randomImageSize = '${_random.nextInt(800) + 1000}x${_random.nextInt(800) + 1000}';

    final restaurant = AttaRestaurant(
      id: generateUuidFromNumber(i),
      name: faker.food.restaurant(),
      imageUrl: 'https://source.unsplash.com/random/$randomImageSize?restaurant',
      category: [AttaCategoryFilter.values[_random.nextInt(AttaCategoryFilter.values.length)]],
      address: faker.address.streetAddress(),
      city: faker.address.city(),
      description: faker.lorem.sentence(),
      email: faker.internet.email(),
      phone: faker.phoneNumber.random.toString(),
      website: faker.internet.domainWord(),
      openingTimes: _generateOpeningTimes(),
      dishes: _generateDishes(),
      menus: _generateMenus(),
    );
    mockedData.add(restaurant);
  }

  return mockedData;
}

List<AttaDish> _generateDishes() {
  return List.generate(_random.nextInt(10) + 1, (index) {
    final randomImageSize = '${_random.nextInt(800) + 800}x${_random.nextInt(800) + 800}';

    return AttaDish(
      id: '$index',
      name: faker.food.dish(),
      imageUrl: 'https://source.unsplash.com/random/$randomImageSize?dish',
      description: faker.lorem.sentence(),
      price: _random.nextDouble() * 20,
      ingredients: 'Ingredient 1, Ingredient 2, Ingredient 3',
    );
  });
}

List<AttaMenu> _generateMenus() {
  return List.generate(_random.nextInt(5) + 1, (index) {
    final randomImageSize = '${_random.nextInt(800) + 800}x${_random.nextInt(800) + 800}';

    return AttaMenu(
      id: '$index',
      name: faker.lorem.word(),
      imageUrl: 'https://source.unsplash.com/random/$randomImageSize?menu',
      description: faker.lorem.sentence(),
      price: _random.nextDouble() * 30,
      dishIds: List.generate(
        _random.nextInt(3) + 1,
        (index) => '$index',
      ),
    );
  });
}

Map<AttaDay, List<AttaOpeningHoursSlots>> _generateOpeningTimes() {
  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingTimes = {};

  for (final day in AttaDay.values) {
    openingTimes[day] = List.generate(
      _random.nextInt(2) + 1,
      (index) => AttaOpeningHoursSlots(
        open: TimeOfDay(hour: _random.nextInt(12), minute: 0),
        close: TimeOfDay(hour: _random.nextInt(12) + 12, minute: 0),
      ),
    );
  }

  return openingTimes;
}

String generateUuidFromNumber(int number) {
  String hexString = number.toRadixString(16);
  while (hexString.length < 32) {
    hexString = '0$hexString';
  }
  return '${hexString.substring(0, 8)}-${hexString.substring(8, 12)}-${hexString.substring(12, 16)}-${hexString.substring(16, 20)}-${hexString.substring(20)}';
}
