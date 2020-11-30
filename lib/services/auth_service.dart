import 'package:firebase_auth/firebase_auth.dart';
import 'package:yibe_final_ui/model/private_user_model.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/messaging_service.dart';
import 'package:yibe_final_ui/utils/helper_functions.dart';

class AuthenticationService {
  static AuthenticationService instance = AuthenticationService();
  static PrivateUserModel pvtUserMap = PrivateUserModel();
  FirebaseAuth _firebaseAuth;

  AuthenticationService() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<String> signUp({String email, String password, String fullName, String userName}) async {
    try {
       User user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      print('user id' + user.uid);
      await user.updateProfile(displayName: fullName).then((value) => passPvtUserInfoToDb(user, fullName, userName));
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      AuthenticationService.instance.signOut();   //make current user null so that even if user does not verify email he wont be signed in
      return ('Sign up successful. Verify your email address to sign in');
    } on FirebaseAuthException catch (e) {
      return (e.message);
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      if((await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password))!=null){
        final User user = _firebaseAuth.currentUser;
        print(user.uid);
        if(user.emailVerified) {
          await DatabaseService.instance.getPvtCurrentUserInfo(user.uid).then((value) => setSP(user, value['profId'], value['username']));
          return 'Sign In Successful';
        } else{
          return 'Verify your email first';
        }
      }

    } on FirebaseAuthException catch (e) {
      return (e.message);
    }
  }

  Future<String> signOut() async {
    await _firebaseAuth.signOut();
    return 'Sign Out successful';
  }

  Future<void> setSP(User user, String profUid, String username) async {
    print(username);
    await HelperFunction.saveUserPvtUidAsSharedPreference(user.uid);
    await HelperFunction.saveFullNameAsSharedPreference(user.displayName);
    await HelperFunction.saveUserEmailIdAsSharedPreference(user.email);
    await HelperFunction.saveUserNameAsSharedPreference(username);
    await HelperFunction.saveUserProfUidAsSharedPreference(profUid);
  }

  void passPvtUserInfoToDb(User user, String fullName, String userName) async {
    pvtUserMap = PrivateUserModel(
      pvtid: user.uid,
      fullname: fullName,
      username: userName,
      emailId: user.email,
      accountType: 'Private',
      haveProfAc: false,
      fcmToken: await MessagingService.instance.getToken(),
    );
    print(pvtUserMap.toMap(pvtUserMap));
    await DatabaseService.instance.createPvtUserInDB(pvtUserMap.toMap(pvtUserMap), user.uid);
    await DatabaseService.instance.createPvtUserInAllUserCollection(pvtUserMap.toMap(pvtUserMap), user.uid);
  }

}