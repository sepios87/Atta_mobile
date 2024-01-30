import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<AttaUser?> alreadyConnectedUser() async {
    try {
      final user = supabase.auth.currentUser;
      return user == null ? null : await _getUserFromDb(user);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> forgetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<AttaUser> createAccount(String email, String password) async {
    final auth = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (auth.user == null) throw Exception('User not found');
    return _getUserFromDb(auth.user!);
  }

  Future<AttaUser> login(String email, String password) async {
    final auth = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (auth.user == null) throw Exception('User not found');
    return _getUserFromDb(auth.user!);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> updateUser(AttaUser user) async {
    try {
      await supabase.from('users').update(user.toMapForDb()).eq('id', user.id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AttaUser> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(
      serverClientId: '483884968558-q61qivnvh51qcl1rumoholvl73ecck5s.apps.googleusercontent.com',
    ).signIn();
    final googleAuth = await googleUser?.authentication;
    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null || idToken == null) {
      throw Exception('Google sign in failed');
    }

    final auth = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (auth.user == null) throw Exception('User not found');
    final userExistInDatabase = await _userExistInDatabase(auth.user!.id);

    if (!userExistInDatabase) {
      final user = AttaUser(
        id: auth.user!.id,
        firstName: googleUser?.displayName,
        imageUrl: googleUser?.photoUrl,
      );
      await supabase.from('users').insert(user.toMapForDb());
    }

    return _getUserFromDb(auth.user!);
  }

  Future<List<AttaRestaurant>> getAllRestaurants() async {
    try {
      // Not necessary to get dish into menu now
      final data = await supabase.from('restaurants').select('*, dishs(*), menus(*)');
      return data.map(AttaRestaurant.fromMap).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> removeFavoriteRestaurant(int restaurantId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not found');
      await supabase.from('favorite_restaurants').delete().eq('user_id', user.id).eq('restaurant_id', restaurantId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addFavoriteRestaurant(int restaurantId) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not found');
    await supabase.from('favorite_restaurants').insert({'user_id': user.id, 'restaurant_id': restaurantId});
  }

  /// Get the user from the database, if it doesn't exist, create it
  Future<AttaUser> _getUserFromDb(User user) async {
    final existantUserInDb = await _getAttaUserFromId(user);

    if (existantUserInDb == null) {
      final newUser = AttaUser(id: user.id);
      await supabase.from('users').insert(newUser.toMapForDb());
      return _getUserFromDb(user);
    }

    return existantUserInDb;
  }

  Future<AttaUser?> _getAttaUserFromId(User user) async {
    // Create favoritesRestaurantIds alias to get the list of favorites restaurants
    final data = await supabase.from('users').select('*, favoritesRestaurantIds:restaurants(id)').eq('id', user.id);
    if (data.isEmpty) return null;
    return AttaUser.fromMap(data.first, user.email);
  }

  Future<bool> _userExistInDatabase(String id) async {
    final data = await supabase.from('users').select().eq('id', id);
    return data.isNotEmpty;
  }
}
