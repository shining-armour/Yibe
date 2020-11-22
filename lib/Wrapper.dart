import 'package:collegesection/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/authenicate/auth_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserDetails user = Provider.of<UserDetails>(context);
    if (user == null) {
      return AuthScreen();
    } else {
      return Home();
    }
  }
}
