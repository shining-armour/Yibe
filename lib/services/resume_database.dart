import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yibe_final_ui/helper/Constants.dart';

class ResumeDatabase {
  //var uid = Constants.uid;
  var uid = Constants.uid;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future addSkill(String skill) async {
    var map = {"type": "skills", "information": skill};
    await usersCollection.doc(uid).collection('Resume').add(map);
    QuerySnapshot snapshot =
        await usersCollection.doc(uid).collection('Resume').get();
    snapshot.docs.forEach((element) {
      element['type'] == 'skills'
          ? print('${element['information']} is skill')
          : print('not');
    });
  }

  Future addInterest(String interest) async {
    var map = {"type": "interset", "information": interest};
    await usersCollection.doc(uid).collection('Resume').add(map);
    QuerySnapshot snapshot =
        await usersCollection.doc(uid).collection('Resume').get();
    snapshot.docs.forEach((element) {
      element['type'] == 'interest'
          ? print('${element['information']} is skill')
          : print('not');
    });
  }

  Future addExperienceDetials(
      String title,
      String type,
      String company,
      String location,
      String startDate,
      String endDate,
      String description,
      File image) async {
    print("expreience");
    var images = '';
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      String firebaseImageLink = downloadUrl.toString();
      images = firebaseImageLink;
      print(images);
    }
    var map = {
      "type": "experence",
      "title": title,
      "company": company,
      "location": location,
      "startDate": startDate,
      "endDate": endDate,
      "description": description,
      "image": images
    };
    await usersCollection.doc(uid).collection('Resume').add(map);
  }

  Future addEducation(
      String school,
      String degree,
      String field,
      String startDate,
      String endDate,
      String grade,
      String description,
      String activity,
      File image) async {
    var images = '';
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      String firebaseImageLink = downloadUrl.toString();
      images = firebaseImageLink;
      print(images);
    }
    var map = {
      "type": "education",
      "school": school,
      "degree": degree,
      "field": field,
      "startDate": startDate,
      "endDate": endDate,
      "grade": grade,
      "description": description,
      "activity": activity,
      "image": images
    };

    await usersCollection.doc(uid).collection('Resume').add(map);
  }

  Future addAchivement(String title, String code, String description,
      String link, String date, File image) async {
    var images = '';
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      String firebaseImageLink = downloadUrl.toString();
      images = firebaseImageLink;
      print(images);
    }
    var map = {
      "type": "achievement",
      "title": title,
      "code": code,
      "description": description,
      "link": link,
      "date": date,
      "image": images
    };
    await usersCollection.doc(uid).collection('Resume').add(map);
  }

  Future<QuerySnapshot> getData() async {
    return await usersCollection.doc(uid).collection('Resume').get();
  }

  Future<QuerySnapshot> getUserDetail() async {
    print(uid);
    QuerySnapshot snapshot =
        await usersCollection.doc(uid).collection('PersonalInfo').get();
    if (snapshot.docs.length > 0) {
      return snapshot;
    } else {
      DocumentSnapshot userRef = await usersCollection.doc(uid).get();
      String email = userRef['emailId'];
      String id = userRef['userName'];

      String userName = userRef['fullname'];
      print(userName);
      print(email);
      print(id);
      Map<String, dynamic> map = {
        'userName': userName,
        'organiserId': id,
        'age': 'age',
        'phone': 'phone',
        'city': 'city',
        'add': 'address',
        'email': email,
        'linkedIn': 'linkedIn',
        'twitter': 'twitter',
      };
      await usersCollection.doc(uid).collection('PersonalInfo').add(map);
      return await usersCollection.doc(uid).collection('PersonalInfo').get();
    }
  }

  Future addPersonalDetail(
      String userName,
      String id,
      String age,
      String phone,
      String city,
      String address,
      String email,
      String linkedIn,
      String twitter) async {
    Map<String, dynamic> map = {
      'userName': userName,
      'organiserId': id,
      'age': age,
      'phone': phone,
      'city': city,
      'add': address,
      'email': email,
      'linkedIn': linkedIn,
      'twitter': twitter,
    };
    await usersCollection.doc(uid).collection('PersonalInfo').add(map);
  }
}
