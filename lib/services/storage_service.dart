import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class StorageService {

  static StorageService instance = StorageService();
  FirebaseStorage _storage;

  StorageService() {
    _storage = FirebaseStorage.instance;
  }

  final String _pvtProfiles = 'private_ac_profiles';
  final String _profProfiles = 'prof_ac_profiles';
  final String _imagesShared = 'images_shared';
  final String _pvtPosts = 'private_posts';
  final String _profPosts = 'prof_posts';

  Future<String> uploadPrivateProfilePic(File _image, String uid) async {
    if (_image != null) {
      var snapshot = await _storage.ref().child(_pvtProfiles).child(uid).putFile(_image).onComplete;
      var url = await snapshot.ref.getDownloadURL();
      //await DatabaseService.instance.updatePvtProfilePic(url.toString());
      return url.toString();
    }
    else {
      var url = await _storage.ref().child('noprofile.jpeg').getDownloadURL();
      return url.toString();
    }
  }


  Future<String> uploadProfProfilePic(File _image, String uid) async {
    if (_image != null) {
      var snapshot = await _storage.ref().child(_profProfiles).child(uid).putFile(_image).onComplete;
      var url = await snapshot.ref.getDownloadURL();
     // await UserDatabaseService.instance.updateProfProfilePic(url.toString());
      return url.toString();
    }
    else {
      var url = await _storage.ref().child('noprofile.jpeg').getDownloadURL();
      return url.toString();
    }
  }

  // ignore: missing_return
  Future<String> uploadMessageTypeImage(File _image, String uid) async {
    try{
      var snapshot = await _storage.ref().child(_imagesShared).child(uid).child(DateTime.now().toString()).putFile(_image).onComplete;
      var url = await snapshot.ref.getDownloadURL();
      return url.toString();
  } catch(e){
      print(e + 'cannot upload');
    }
    }

  // ignore: missing_return
  Future<String> uploadPvtPostImage(File _image) async {
    try{
      var snapshot = await _storage.ref().child(_pvtPosts).child(UniversalVariables.myPvtUid).child(DateTime.now().toString()).putFile(_image).onComplete;
      var url = await snapshot.ref.getDownloadURL();
      return url.toString();
    } catch(e){
      print(e + 'cannot upload');
    }
  }

  // ignore: missing_return
  Future<String> uploadProfPostImage(File _image) async {
    try{
      var snapshot = await _storage.ref().child(_profPosts).child(UniversalVariables.myProfUid).child(DateTime.now().toString()).putFile(_image).onComplete;
      var url = await snapshot.ref.getDownloadURL();
      return url.toString();
    } catch(e){
      print(e + 'cannot upload');
    }
  }

}

