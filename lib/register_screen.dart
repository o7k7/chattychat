import 'package:chattychat/asymmetric_button.dart';
import 'package:chattychat/chatty_screen.dart';
import 'package:chattychat/styles.dart';
import 'package:chattychat/util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

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
            Flexible(
              child: Hero(
                tag: 'ic_splash',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/ic_splash.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  style_edit_text.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration:
                  style_edit_text.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            AsymmetricButton(
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChattyScreen.id);
                  }
                } catch (e) {
                  if (e is PlatformException) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Util.showDialog(context, e.message),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
