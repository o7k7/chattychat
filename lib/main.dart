import 'package:chattychat/authentication_screen.dart';
import 'package:chattychat/chatty_screen.dart';
import 'package:chattychat/login_screen.dart';
import 'package:chattychat/register_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChattyChatApp());

class ChattyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: AuthenticationScreen.id,
        routes: {
          AuthenticationScreen.id: (context) => AuthenticationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          ChattyScreen.id: (context) => ChattyScreen(),
        });
  }
}