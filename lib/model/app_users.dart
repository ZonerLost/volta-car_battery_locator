import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final Timestamp createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    "uid": uid,
    "email": email,
    "fullName": fullName,
    "createdAt": createdAt,
  };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    uid: (map["uid"] ?? "") as String,
    email: (map["email"] ?? "") as String,
    fullName: (map["fullName"] ?? "") as String,
    createdAt: (map["createdAt"] ?? Timestamp.now()) as Timestamp,
  );
}
