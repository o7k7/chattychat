import 'package:chattychat/register_screen.dart';
import 'package:flutter/material.dart';

import 'asymmetric_button.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String id = 'authentication_screen';

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Image.asset('images/ic_splash.jpg'),
              height: 200.0,
            ),
            SizedBox(
              height: 48.0,
            ),
            AsymmetricButton(
              title: 'Log In',
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            AsymmetricButton(
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
