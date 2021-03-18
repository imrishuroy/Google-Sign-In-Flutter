import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_flutter/models/app_user.dart';
import 'package:google_sign_in_flutter/screens/login_screen.dart';
import 'package:google_sign_in_flutter/screens/sucess_screen.dart';
import 'package:google_sign_in_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  final firebaseAuth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');

  Future<bool> checkAvailabledata(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    if (!doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServices>(context);
    return StreamBuilder<AppUser?>(
      stream: auth.onAuthChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          AppUser? appUser = snapshot.data;
          if (appUser == null) {
            print(appUser?.uid);
            return LoginScreen();
          } else {
            return SucussScreen();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
