import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_flutter/models/app_user.dart';

abstract class AuthServices {
  Stream<AppUser?> get onAuthChanges;
  Future<AppUser?> currentUser();
  Future<AppUser?> signInWithGoogle();
  Future<void> signOut();
}

class Auth extends AuthServices {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<AppUser?> get onAuthChanges {
    return _auth.authStateChanges().map(_appUser);
  }

  @override
  Future<AppUser?> currentUser() async {
    final user = _auth.currentUser;
    return _appUser(user);
  }

  AppUser? _appUser(User? user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(
        uid: user.uid,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential =
            await _auth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        print(userCredential.user?.photoURL);
        return _appUser(userCredential.user);
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
