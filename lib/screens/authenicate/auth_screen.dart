import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collegesection/screens/authenicate/register.dart';
import 'package:collegesection/screens/authenicate/signin.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _register = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _register ? Text('Register') : Text('Sign In'),
        actions: [
          FlatButton.icon(
            onPressed: () {
              setState(() {
                _register = !_register;
              });
            },
            icon: Icon(Icons.person),
            label: _register ? Text('Sign In') : Text('Register'),
          ),
        ],
      ),
      body: _register ? Register() : SignIn(),
    );
  }
}
