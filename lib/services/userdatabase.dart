import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final ref = FirebaseDatabase.instance.reference();

  Future updateUserData(String username, String email) async {
    return await userCollection
        .doc(uid)
        .set({'username': username, 'email': email});
  }

  Future updateUserDataWithDetails(
      double lat, double long, String deviceToken) async {
    return await userCollection.doc(uid).update(
        {'latitude': lat, 'longitude': long, 'deviceToken': deviceToken});
    // ref.child("Users").child(uid).set({'deviceToken': deviceToken});
  }
}
