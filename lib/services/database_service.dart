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
      return user == null ? null : await _getUserFromDb(user.id);
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
    return _getUserFromDb(auth.user!.id);
  }

  Future<AttaUser> login(String email, String password) async {
    final auth = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (auth.user == null) throw Exception('User not found');
    return _getUserFromDb(auth.user!.id);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> updateUser(AttaUser user) async {
    try {
      await supabase.from('users').update(user.toMap()).eq('id', user.id);
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
    return _getUserFromDb(auth.user!.id);
  }

  /// Get the user from the database, if it doesn't exist, create it
  Future<AttaUser> _getUserFromDb(String id) async {
    final existantUserInDb = await _getAttaUserFromId(id);

    if (existantUserInDb == null) {
      final user = AttaUser(id: id);
      await supabase.from('users').insert(user.toMap());
      return _getUserFromDb(id);
    }

    return existantUserInDb;
  }

  Future<AttaUser?> _getAttaUserFromId(String id) async {
    // Create favoritesRestaurantIds alias to get the list of favorites restaurants
    final data = await supabase.from('users').select('*, favoritesRestaurantIds:restaurants(id)').eq('id', id);
    if (data.isEmpty) return null;
    return AttaUser.fromMap(data.first);
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
      print('remove');
      if (user == null) throw Exception('User not found');
      print('remove1');

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
}
