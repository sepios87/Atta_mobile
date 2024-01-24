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
    final user = await databaseService.alreadyConnectedUser();
    _userStreamController.add(user);
  }

  Future<void> forgetPassword(String email) async {
    await databaseService.forgetPassword(email);
  }

  Future<void> logout() async {
    await databaseService.logout();
    _userStreamController.add(null);
  }

  Future<void> login(String email, String password) async {
    final user = await databaseService.login(email, _encryptPassword(password));
    _userStreamController.add(user);
  }

  Future<void> createAccount(String email, String password) async {
    final user = await databaseService.createAccount(email, _encryptPassword(password));
    _userStreamController.add(user);
  }

  Future<void> signInWithGoogle() async {
    final user = await databaseService.signInWithGoogle();
    _userStreamController.add(user);
  }

  Future<void> toggleFavoriteRestaurant(int restaurantId) async {
    final newUser = user?.copy();

    if (newUser?.favoritesRestaurantIds.contains(restaurantId) ?? false) {
      newUser?.favoritesRestaurantIds.remove(restaurantId);
      await databaseService.removeFavoriteRestaurant(restaurantId);
    } else {
      newUser?.favoritesRestaurantIds.add(restaurantId);
      await databaseService.addFavoriteRestaurant(restaurantId);
    }

    _userStreamController.add(newUser);
  }

  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
