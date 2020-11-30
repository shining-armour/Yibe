import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesDatabase {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot> getUserPreferenceData() async {
    var uid = "JkG0HvAYMotUg8rMz6ug";
    QuerySnapshot snapshot =
        await usersCollection.doc(uid).collection('Prefrences').get();
    if (snapshot.docs.length > 0) {
      return snapshot;
    } else {
      Map<String, dynamic> map = {
        'enableYibe': false,
        'internShip': false,
        'quickFix': false,
        'startUp': false,
        'willingTeach': false,
        'isAnyOne': false,
      };
      await usersCollection.doc(uid).collection('Prefrences').doc(uid).set(map);
      snapshot = await usersCollection.doc(uid).collection('Prefrences').get();
    }
    return snapshot;
  }

  Future updatePreferences(bool enableYibe, bool internShip, bool quickFix,
    bool startUp, bool willingTeach, bool isAnyOne) async {
    var uid = "JkG0HvAYMotUg8rMz6ug";
    Map<String, dynamic> map = {
      'enableYibe': enableYibe,
      'internShip': internShip,
      'quickFix': quickFix,
      'startUp': startUp,
      'willingTeach': willingTeach,
      'isAnyOne': isAnyOne,
    };
    await usersCollection.doc(uid).collection('Prefrences').doc(uid).set(map);
  }
}
