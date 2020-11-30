import 'package:flutter/foundation.dart';

class AcType extends ChangeNotifier{
  bool isPrivate = true;
  bool get privateBool => isPrivate;

  changeAcType(){
    isPrivate =! isPrivate;
    notifyListeners();
  }
}