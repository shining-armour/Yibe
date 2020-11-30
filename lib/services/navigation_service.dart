import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey;
  static NavigationService instance = NavigationService();

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> pushReplacementNamedTo(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> pushNamedTo(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> pushTo(MaterialPageRoute _route) {
    return navigatorKey.currentState.push(_route);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
