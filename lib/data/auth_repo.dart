import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepo {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthRepo({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  // =========================
  // EMAIL/PASSWORD SIGNUP
  // =========================
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      await _db.collection("users").doc(uid).set({
        "uid": uid,
        "email": email,
        "fullName": fullName,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Signup failed");
    }
  }

  // =========================
  // EMAIL/PASSWORD LOGIN
  // =========================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user?.uid;
      if (uid != null) {
        await _db.collection("users").doc(uid).set({
          "updatedAt": FieldValue.serverTimestamp(),
          "lastLoginAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // =========================
  // FORGOT PASSWORD
  // =========================
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Reset failed");
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    // Google signout optional (recommended)
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  // =========================
  // GUEST LOGIN
  // =========================
  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  // =========================
  // GOOGLE SIGN IN
  // =========================
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("Google sign-in cancelled");
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    // optional: ensure user doc exists
    await _ensureUserDoc(userCred.user);

    return userCred;
  }

  // =========================
  // APPLE SIGN IN
  // =========================
  Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final userCred = await _auth.signInWithCredential(oauthCredential);

    // optional: ensure user doc exists
    await _ensureUserDoc(userCred.user, appleCredential: appleCredential);

    return userCred;
  }

  // =========================
  // CURRENT USER
  // =========================
  User? get currentUser => _auth.currentUser;

  // =========================
  // HELPERS
  // =========================

  Future<void> _ensureUserDoc(User? user,
      {AuthorizationCredentialAppleID? appleCredential}) async {
    if (user == null) return;

    // Apple full name/email only first time sometimes
    final fullNameFromApple = appleCredential == null
        ? null
        : [
      appleCredential.givenName,
      appleCredential.familyName,
    ].where((e) => (e ?? "").trim().isNotEmpty).join(" ").trim();

    final docRef = _db.collection("users").doc(user.uid);
    await docRef.set({
      "uid": user.uid,
      "email": user.email ?? appleCredential?.email ?? "",
      "fullName": (user.displayName?.trim().isNotEmpty ?? false)
          ? user.displayName!.trim()
          : (fullNameFromApple?.isNotEmpty == true ? fullNameFromApple : "User"),
      "updatedAt": FieldValue.serverTimestamp(),
      "lastLoginAt": FieldValue.serverTimestamp(),
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
          (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}