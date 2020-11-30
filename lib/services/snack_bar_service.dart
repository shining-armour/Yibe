import 'package:flutter/material.dart';

class SnackBarService {
  static SnackBarService instance = SnackBarService();

  void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('$text'),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

}