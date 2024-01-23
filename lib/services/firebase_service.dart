import 'package:atta/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  Future<AttaUser?> alreadyConnectedUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return _getUserFromDb(user.uid);
  }

  Future<void> forgetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<AttaUser> createAccount(String email, String password) async {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getUserFromDb(userCredential.user!.uid);
  }

  Future<AttaUser> login(String email, String password) async {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    return _getUserFromDb(user!.uid);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateUser(AttaUser user) async {
    await db.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<AttaUser> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final user = await FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      ),
    );

    if (user.user == null) throw Exception('User not found');
    return _getUserFromDb(user.user!.uid);
  }

  /// Get the user from the database, if it doesn't exist, create it
  Future<AttaUser> _getUserFromDb(String uid) async {
    final existantUserInDb = await _getAttaUserFromUid(uid);
    if (existantUserInDb == null) {
      final attaUser = AttaUser(uid: uid);
      await db.collection('users').doc(attaUser.uid).set(attaUser.toMap());
      return attaUser;
    }

    return existantUserInDb;
  }

  Future<AttaUser?> _getAttaUserFromUid(String uid) async {
    final doc = await db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AttaUser.fromMap(doc.id, doc.data()!);
  }
}
