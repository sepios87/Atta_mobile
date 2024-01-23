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
    final user = await firebaseService.alreadyConnectedUser();
    _userStreamController.add(user);
  }

  Future<void> forgetPassword(String email) async {
    await firebaseService.forgetPassword(email);
  }

  Future<void> logout() async {
    await firebaseService.logout();
    _userStreamController.add(null);
  }

  Future<void> login(String email, String password) async {
    final user = await firebaseService.login(email, _encryptPassword(password));
    _userStreamController.add(user);
  }

  Future<void> createAccount(String email, String password) async {
    final user = await firebaseService.createAccount(email, _encryptPassword(password));
    _userStreamController.add(user);
  }

  Future<void> signInWithGoogle() async {
    final user = await firebaseService.signInWithGoogle();
    _userStreamController.add(user);
  }

  Future<void> toggleFavoriteRestaurant(String restaurantId) async {
    final newUser = user?.copy();
    if (newUser == null) throw Exception('User not found');
    if (newUser.favoritesRestaurantsId.contains(restaurantId)) {
      newUser.favoritesRestaurantsId.remove(restaurantId);
    } else {
      newUser.favoritesRestaurantsId.add(restaurantId);
    }

    await firebaseService.updateUser(newUser);
    _userStreamController.add(newUser);
  }

  Future<void> toggleFavoriteDish(String dishId) async {
    final newUser = user?.copy();
    if (newUser == null) throw Exception('User not found');
    if (newUser.favoritesDishesId.contains(dishId)) {
      newUser.favoritesDishesId.remove(dishId);
    } else {
      newUser.favoritesDishesId.add(dishId);
    }

    await firebaseService.updateUser(newUser);
    _userStreamController.add(newUser);
  }

  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
