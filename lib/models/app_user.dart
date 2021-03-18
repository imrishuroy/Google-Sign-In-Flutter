import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? uid;
  final String? name;

  final String? photoUrl;

  AppUser({
    this.uid,
    this.name,
    this.photoUrl,
  });

  // serializing our own object from firebase user class
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: doc['uid'],
      photoUrl: doc['photoUrl'],
      name: doc['name'],
    );
  }
}
