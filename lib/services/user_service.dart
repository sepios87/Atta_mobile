import 'dart:convert';
import 'dart:io';

import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
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
    final newUser = user?.copyWith();
    final favoriteRestaurantIds = newUser?.favoritesRestaurantIds;
    if (newUser == null || favoriteRestaurantIds == null) return;

    if (favoriteRestaurantIds.contains(restaurantId)) {
      newUser.favoritesRestaurantIds.remove(restaurantId);
      await databaseService.removeFavoriteRestaurant(restaurantId);
    } else {
      newUser.favoritesRestaurantIds.add(restaurantId);
      await databaseService.addFavoriteRestaurant(restaurantId);
    }

    _userStreamController.add(newUser);
  }

  Future<void> toggleFavoriteDish({required int restaurantId, required int dishId}) async {
    final newUser = user?.copyWith();
    final favoriteDishesIds = newUser?.favoriteDishesIds;
    if (newUser == null || favoriteDishesIds == null) return;

    if (favoriteDishesIds.contains((dishId, restaurantId))) {
      newUser.favoriteDishesIds.remove((dishId, restaurantId));
      await databaseService.removeFavoriteDish(restaurantId, dishId);
    } else {
      newUser.favoriteDishesIds.add((dishId, restaurantId));
      await databaseService.addFavoriteDish(restaurantId, dishId);
    }

    _userStreamController.add(newUser);
  }

  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  void removeReservation(int reservationId) {
    final newUser = user?.copyWith();
    newUser?.reservations.removeWhere((r) => r.id == reservationId);
    _userStreamController.add(newUser);
  }

  void addOrUpdateReservation(AttaReservation reservation) {
    final newUser = user?.copyWith();
    newUser?.reservations.removeWhere((r) => r.id == reservation.id);
    newUser?.reservations.add(reservation);
    _userStreamController.add(newUser);
  }

  Future<String> uploadAvatarImage(File imageFile) async {
    final bucketPathDestination = '${user?.id}/avatars/${DateTime.now().millisecondsSinceEpoch}';
    return databaseService.uploadUserAvatar(bucketPathDestination, imageFile);
  }

  Future<void> updateProfile({
    required Wrapped<String?> firstName,
    required Wrapped<String?> lastName,
    required Wrapped<String?> phone,
    Wrapped<String?>? imageUrl,
  }) async {
    final newUser = user?.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      imageUrl: imageUrl,
    );
    _userStreamController.add(newUser);
    await databaseService.updateUser(newUser!);
  }
}
