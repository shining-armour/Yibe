import 'package:flutter/foundation.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class AcType extends ChangeNotifier{
  bool isPrivate = true;
  String selectedOption = 'All';
  Stream showFeeds = DatabaseService.instance.getAllMyPvtFeeds();
  bool get privateBool => isPrivate;
  Stream get selectedStream => showFeeds;

  changeAcType(){
    isPrivate =! isPrivate;
    notifyListeners();
  }

  setDefaultAcTypeToPrivate(){
    isPrivate = true;
    notifyListeners();
  }

  setFeedStreamToNull(){
   selectedOption = null;
   notifyListeners();
  }

  changeShowFeedsOf(String value){
    selectedOption = value;

    if(value =='CF'){
      showFeeds = DatabaseService.instance.getAllCloseFriendsFeeds();
    } else if( value == 'F'){
    showFeeds = DatabaseService.instance.getAllFriendsFeeds();
    } else if( value == 'AQ'){
      showFeeds = DatabaseService.instance.getAllAcquaintanceFeeds();
    } else if( value == 'Following'){
      showFeeds = DatabaseService.instance.getAllPvtFollowingsFeeds();
    } else {
      showFeeds = DatabaseService.instance.getAllMyPvtFeeds();
    }
    notifyListeners();
  }
}