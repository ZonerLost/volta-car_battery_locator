import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepo {
  static const _googleWebClientId =
      "33594735082-2afpfnnkllodv6sd7h5vlt2o8gelraj7.apps.googleusercontent.com";
  static const _googleIosClientId =
      "33594735082-fhi79t8d4cehck930gp6ii7togamf2hg.apps.googleusercontent.com";

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
      throw Exception(_friendlyAuthMessage(e));
    }
  }

  // =========================
  // EMAIL/PASSWORD LOGIN
  // =========================
  Future<void> login({required String email, required String password}) async {
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
      throw Exception(_friendlyAuthMessage(e));
    }
  }

  // =========================
  // FORGOT PASSWORD
  // =========================
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    final raw = email.trim();
    final normalized = email.trim().toLowerCase();
    final users = _db.collection("users");
    final normalizedSnap =
        await users.where("email", isEqualTo: normalized).limit(1).get();
    if (normalizedSnap.docs.isNotEmpty) return true;

    if (raw == normalized) return false;

    final rawSnap = await users.where("email", isEqualTo: raw).limit(1).get();
    return rawSnap.docs.isNotEmpty;
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
    if (kIsWeb) {
      throw Exception("Google sign-in is not configured for web.");
    }

    try {
      final googleSignIn = GoogleSignIn(
        clientId:
            defaultTargetPlatform == TargetPlatform.iOS
                ? _googleIosClientId
                : null,
        serverClientId: _googleWebClientId,
        scopes: const ["email", "profile"],
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in cancelled");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw Exception("Google did not return a valid sign-in token.");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      await _ensureUserDoc(userCred.user);
      return userCred;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        "GOOGLE FIREBASE AUTH ERROR => code=${e.code}, message=${e.message}",
      );
      throw Exception(e.message ?? "Google sign-in failed");
    } on PlatformException catch (e) {
      debugPrint(
        "GOOGLE PLATFORM ERROR => code=${e.code}, message=${e.message}, details=${e.details}",
      );
      throw Exception(_friendlyGooglePlatformMsg(e));
    } catch (e) {
      debugPrint("GOOGLE SIGN-IN ERROR => $e");
      throw Exception("Google sign-in failed: $e");
    }
  }

  String _friendlyGooglePlatformMsg(PlatformException e) {
    final raw =
        [
          e.code,
          e.message,
          e.details?.toString(),
        ].whereType<String>().join(" ").toLowerCase();

    if (raw.contains("10") || raw.contains("developer_error")) {
      return "Google sign-in is not configured correctly. Please check Firebase SHA-1/SHA-256 and download a fresh google-services.json.";
    }
    if (raw.contains("12500") || raw.contains("sign_in_failed")) {
      return "Google sign-in failed. Check that the Google provider is enabled in Firebase and OAuth consent/app configuration is complete.";
    }
    if (raw.contains("7") || raw.contains("network")) {
      return "Network issue while signing in with Google. Please check your internet and try again.";
    }
    if (raw.contains("canceled") || raw.contains("cancelled")) {
      return "Google sign-in was cancelled.";
    }

    return e.message ?? "Google sign-in failed. Please try again.";
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

    final oauthCredential = OAuthProvider(
      "apple.com",
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    final userCred = await _auth.signInWithCredential(oauthCredential);

    // optional: ensure user doc exists
    await _ensureUserDoc(userCred.user, appleCredential: appleCredential);

    return userCred;
  }

  // =========================
  // CURRENT USER
  // =========================
  User? get currentUser => _auth.currentUser;

  String _friendlyAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-credential":
      case "wrong-password":
      case "user-not-found":
        return "Email or password is incorrect. Please try again.";
      case "invalid-email":
        return "Please enter a valid email address.";
      case "email-already-in-use":
        return "An account already exists with this email.";
      case "weak-password":
        return "Password must be at least 6 characters.";
      case "too-many-requests":
        return "Too many attempts. Please try again later.";
      case "network-request-failed":
        return "Network issue. Please check your internet and try again.";
      default:
        return e.message ?? "Something went wrong. Please try again.";
    }
  }

  // =========================
  // HELPERS
  // =========================

  Future<void> _ensureUserDoc(
    User? user, {
    AuthorizationCredentialAppleID? appleCredential,
  }) async {
    if (user == null) return;

    // Apple full name/email only first time sometimes
    final fullNameFromApple =
        appleCredential == null
            ? null
            : [
              appleCredential.givenName,
              appleCredential.familyName,
            ].where((e) => (e ?? "").trim().isNotEmpty).join(" ").trim();

    final docRef = _db.collection("users").doc(user.uid);
    await docRef.set({
      "uid": user.uid,
      "email": user.email ?? appleCredential?.email ?? "",
      "fullName":
          (user.displayName?.trim().isNotEmpty ?? false)
              ? user.displayName!.trim()
              : (fullNameFromApple?.isNotEmpty == true
                  ? fullNameFromApple
                  : "User"),
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
