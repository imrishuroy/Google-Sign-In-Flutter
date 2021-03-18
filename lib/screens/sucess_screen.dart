import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_flutter/services/auth_service.dart';
import 'package:provider/provider.dart';

class SucussScreen extends StatelessWidget {
  final googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServices>(context, listen: false);
    print(googleSignIn.currentUser?.photoUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Succuss'),
        actions: [
          TextButton.icon(
            onPressed: () => auth.signOut(),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              'LOGOUT',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15.0),
        ],
      ),
    );
  }
}
