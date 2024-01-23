import 'dart:convert';

import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:crypto/crypto.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final _userStreamController = BehaviorSubject<AttaUser?>.seeded(null);

  AttaUser? get user => _userStreamController.value;
  Stream<AttaUser?> get userStream => _userStreamController.stream;
  bool get isLogged => user != null;

  Future<void> init() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    // await login('', '');
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _userStreamController.add(null);
  }

  Future<void> login(String email, String password) async {
    final user = await storageService.getUser(email, encryptPassword(password));
    if (user == null) throw Exception('User not found');
    _userStreamController.add(user);
  }

  Future<void> createAccount(String email, String password) async {
    final isUserExist = await storageService.isUserExist(email);
    if (isUserExist) throw Exception('User already exist');
    final user = AttaUser(email: email, password: encryptPassword(password));
    await storageService.saveUser(user);
    _userStreamController.add(user);
  }

  Future<void> addFavoriteRestaurant(String restaurantId) async {
    final currentUser = user;
    if (currentUser == null) throw Exception('User not found');
    currentUser.favoritesRestaurantsId.add(restaurantId);
    await storageService.saveUser(currentUser);
    // _userStreamController.add(user);
    final test = await storageService.getUser(currentUser.email, currentUser.password);
    // print(test?.favoritesRestaurantsId);
    // print(currentUser.id);
    // print(currentUser.favoritesRestaurantsId);
  }

  Future<void> removeFavoriteRestaurant(String restaurantId) async {
    final currentUser = user;
    if (currentUser == null) throw Exception('User not found');
    currentUser.favoritesRestaurantsId.remove(restaurantId);
    await storageService.saveUser(currentUser);
    _userStreamController.add(user);
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
