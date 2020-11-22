import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegesection/models/exp_loc.dart';

class FilteringUsersDatabaseService {
  final CollectionReference expCollection =
      FirebaseFirestore.instance.collection('FilterUsers');

  Future updateLoc(double lat, double long) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('FilterUsers').doc();
    return await documentReference.set({
      'Latitude': lat,
      'Longitude': long,
    });
  }

  Future<List<ExpUser>> getMarkers(int range, double lat, double long) async {
    List<ExpUser> list = [];
    double diffValue = range * 0.005;
    QuerySnapshot snapshot = await expCollection
        .where('Latitude', isGreaterThanOrEqualTo: lat - diffValue)
        .where('Latitude', isLessThanOrEqualTo: lat + diffValue)
//        .where('Longitude', isGreaterThanOrEqualTo: long - diffValue)
//        .where('Longitude', isLessThanOrEqualTo: long + diffValue)
        .get();
    snapshot.docs.forEach((document) {
      double l = document.get('Longitude');
      if ((long - diffValue) < l && (long + diffValue) > l) {
        list.add(ExpUser(
          lat: document.get('Latitude'),
          long: document.get('Longitude'),
        ));
      }
    });
    return list;
  }
}
