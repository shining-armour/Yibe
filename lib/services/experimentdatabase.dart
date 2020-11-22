import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegesection/models/exp_loc.dart';

class ExpDatabaseService {
  final CollectionReference expCollection =
      FirebaseFirestore.instance.collection('Experiment');

  Future updateLoc(double lat, double long) async {
    double x = lat;
    x = x * 100;
    double y = long;
    y = y * 100;
    int latcode = x.toInt();
    int longcode = y.toInt();
    int code = (latcode * 100000) + longcode;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Experiment').doc();
    return await documentReference.set({
      'Latitude': lat,
      'Longitude': long,
      'CellId': code,
    });
  }

  Future<List<ExpLoc>> getMarkers(
      int range, double userLat, double userLong) async {
    List<ExpLoc> list = [];
    print(range.toString() +
        '  ' +
        userLat.toString() +
        ' ' +
        userLong.toString());

    double x = userLat;
    x = x * 100;
    double y = userLong;
    y = y * 100;
    int latcode = x.toInt();
    int longcode = y.toInt();
    int z = range ~/ 2 * -1;
    List<int> lats = [];
    List<int> longs = [];
    for (int i = 0; i < range; i++) {
      lats.add(latcode + z);
      longs.add(longcode + z);
      z++;
    }
    List<int> queryCodes = [];
    for (int i = 0; i < range; i++) {
      int temp = lats[i];
      for (int j = 0; j < range; j++) {
        queryCodes.add((temp * 100000) + longs[j]);
      }
    }

    QuerySnapshot snapshot;
    print(queryCodes);
    if (range != 100) {
      snapshot = await expCollection.where('CellId', whereIn: queryCodes).get();
    } else {
      snapshot = await expCollection.get();
    }
    snapshot.docs.forEach((document) {
      list.add(ExpLoc(
        long: document.get('Longitude'),
        lat: document.get('Latitude'),
        code: document.get('CellId'),
      ));
    });
    print(list);
    return list;
  }
}
