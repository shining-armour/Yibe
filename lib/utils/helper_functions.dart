import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {

  static String sharedPreferenceUserPvtUid = 'UID-PKEY';
  static String sharedPreferenceUserProfUid = 'UID-PRKEY';
  static String sharedPreferenceUserName = 'USERNAMEKEY';
  static String sharedPreferenceFullName = 'FULLNAMEKEY';
  static String sharedPreferenceUserEmailId = 'USEREMAILKEY';
  static String SPisHibernation = 'HIBERNATIONKEY';

  //save shared preferences
  static Future<bool> saveUserPvtUidAsSharedPreference(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserPvtUid, uid);
  }

  static Future<bool> saveUserProfUidAsSharedPreference(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserProfUid, uid);
  }

  static Future<bool> saveFullNameAsSharedPreference(String fullName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceFullName, fullName);
  }

  static Future<bool> saveUserNameAsSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserName, userName);
  }

  static Future<bool> saveUserEmailIdAsSharedPreference(String userEmailId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailId, userEmailId);
  }

  static Future<bool> saveHibernationModeAsSharedPreference(bool isHibernation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(SPisHibernation, isHibernation);
  }


  //fetch shared preferences
  static Future<String> getUserPvtUidSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserPvtUid);
  }

  static Future<String> getUserProfUidSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserProfUid);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserName);
  }

  static Future<String> getFullNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceFullName);
  }

  static Future<String> getUserEmailIdSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserEmailId);
  }

  static Future<bool> getHibernationModeSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(SPisHibernation);
  }


}