part of '../db_service.dart';

extension DatabaseUserService on DatabaseService {
  Future<AttaUser?> alreadyConnectedUser() async {
    try {
      return currentUser == null ? null : await _getUserFromDb(currentUser!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> forgetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<AttaUser> createAccount(String email, String password) async {
    final auth = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (auth.user == null) throw Exception('User not found');
    return _getUserFromDb(auth.user!);
  }

  Future<AttaUser> login(String email, String password) async {
    final auth = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (auth.user == null) throw Exception('User not found');
    return _getUserFromDb(auth.user!);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> updateUser(AttaUser user) async {
    try {
      await _supabase.from('users').update(user.toMapForDb()).eq('id', user.id);
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

    final auth = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (auth.user == null) throw Exception('User not found');
    final userExistInDatabase = await _userExistInDatabase(auth.user!.id);

    if (!userExistInDatabase) {
      final user = AttaUser.fromMinimalData(
        id: auth.user!.id,
        firstName: googleUser?.displayName,
        imageUrl: googleUser?.photoUrl,
      );
      await _supabase.from('users').insert(user.toMapForDb());
    }

    return _getUserFromDb(auth.user!);
  }

  Future<AttaUser?> _getAttaUserFromId(User user) async {
    // Create favoritesRestaurantIds alias to get the list of favorites restaurants
    final data = await _supabase
        .from('users')
        .select(
          '*, favoritesRestaurantIds:restaurants(id), reservations(*), favoritesDishes:dish_restaurant(id, restaurant_id, dish_id)',
        )
        .eq('id', user.id);
    if (data.isEmpty) return null;
    return AttaUser.fromMap(data.first, user.email);
  }

  Future<bool> _userExistInDatabase(String id) async {
    final data = await _supabase.from('users').select().eq('id', id);
    return data.isNotEmpty;
  }

  /// Get the user from the database, if it doesn't exist, create it
  Future<AttaUser> _getUserFromDb(User user) async {
    final existantUserInDb = await _getAttaUserFromId(user);

    if (existantUserInDb == null) {
      final newUser = AttaUser.fromMinimalData(id: user.id);
      await _supabase.from('users').insert(newUser.toMapForDb());
      return _getUserFromDb(user);
    }

    return existantUserInDb;
  }
}
