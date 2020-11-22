import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegesection/models/Activity.dart';
import 'package:flutter/cupertino.dart';

class ActivityDatabaseService {
  final String uid;

  ActivityDatabaseService({this.uid});

  final CollectionReference activityCollection =
      FirebaseFirestore.instance.collection('Activities');

  final CollectionReference sportsCollection =
      FirebaseFirestore.instance.collection('Sports');
  final CollectionReference eSportsCollection =
      FirebaseFirestore.instance.collection('ESports');
  final CollectionReference skillsCollection =
      FirebaseFirestore.instance.collection('Skills');

  Future updateActivityData(ActivityDetails e) async {
    Timestamp time = Timestamp.fromDate(DateTime.now());
    DocumentReference documentReference;
    if (e.activityType == 'Sport') {
      documentReference = FirebaseFirestore.instance.collection('Sports').doc();
      await documentReference.set({
        'Description': e.description,
        'ActivityType': e.activityType,
        'Name': e.activityTitle,
        'TimeOfRegistration': time,
        'Latitude': e.lat,
        'Longitude': e.long,
        'OrganiserId': uid,
        'PlayersReq': e.noOfPlayers
      });
    } else if (e.activityType == 'ESport') {
      documentReference =
          FirebaseFirestore.instance.collection('ESports').doc();
      await documentReference.set({
        'Description': e.description,
        'ActivityType': e.activityType,
        'Name': e.activityTitle,
        'TimeOfRegistration': time,
        'OrganiserId': uid,
        'PlayersReq': e.noOfPlayers
      });
    } else {
      documentReference = FirebaseFirestore.instance.collection('Skills').doc();
      await documentReference.set({
        'Description': e.description,
        'ActivityType': e.activityType,
        'Name': e.activityTitle,
        'TimeOfRegistration': time,
        'OrganiserId': uid,
      });
    }

    return await FirebaseFirestore.instance.collection('Activities').doc().set({
      'OrganiserId': uid,
      'ActivityID': documentReference.id,
      'ActivityType': e.activityType,
      'TimeOfRegistration': time,
    });
  }

  List<Activity> _activitiesFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Activity(
        organiserID: doc.get('OrganiserId'),
        activityType: doc.get('ActivityType'),
        activityId: doc.get('ActivityID'),
      );
    }).toList();
  }

  Stream<List<Activity>> getActivities(int sortingOptions, int type) {
    List<String> activityTypes = ['all', 'Sport', 'ESport', 'Skill'];
    if (type == 0) {
      if (sortingOptions == 0) {
        return activityCollection
            .orderBy('TimeOfRegistration', descending: true)
            .snapshots()
            .map(_activitiesFromSnapshots);
      } else if (sortingOptions == 1) {
        return activityCollection.snapshots().map(_activitiesFromSnapshots);
      } else {
        return activityCollection.snapshots().map(_activitiesFromSnapshots);
      }
    } else {
      if (sortingOptions == 0) {
        return activityCollection
            .where('ActivityType', isEqualTo: activityTypes[type])
            .orderBy('TimeOfRegistration', descending: true)
            .snapshots()
            .map(_activitiesFromSnapshots);
      } else if (sortingOptions == 1) {
        return activityCollection
            .where('ActivityType', isEqualTo: activityTypes[type])
            .snapshots()
            .map(_activitiesFromSnapshots);
      } else {
        return activityCollection
            .where('ActivityType', isEqualTo: activityTypes[type])
            .snapshots()
            .map(_activitiesFromSnapshots);
      }
    }
  }

  ActivityDetails _detailsFromSnapshot(DocumentSnapshot snapshot) {
    return ActivityDetails(
        activityType: snapshot.get('ActivityType'),
        activityTitle: snapshot.get('Name'),
        long: snapshot.get('Longitude') ?? '',
        lat: snapshot.get('Latitude') ?? '',
        noOfPlayers: snapshot.get('PlayersReq') ?? '',
        description: snapshot.get('Description'),
        organiserID: snapshot.get('OrganiserId'),
        aid: snapshot.id);
  }

  ActivityDetails _sportDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return ActivityDetails(
        activityType: snapshot.get('ActivityType'),
        activityTitle: snapshot.get('Name'),
        long: snapshot.get('Longitude') ?? '',
        lat: snapshot.get('Latitude') ?? '',
        noOfPlayers: snapshot.get('PlayersReq') ?? '',
        description: snapshot.get('Description'),
        organiserID: snapshot.get('OrganiserId'),
        aid: snapshot.id);
  }

  ActivityDetails _eSportDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return ActivityDetails(
        activityType: snapshot.get('ActivityType'),
        activityTitle: snapshot.get('Name'),
        long: 0,
        lat: 0,
        noOfPlayers: snapshot.get('PlayersReq') ?? '',
        description: snapshot.get('Description'),
        organiserID: snapshot.get('OrganiserId'),
        aid: snapshot.id);
  }

  ActivityDetails _skillDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return ActivityDetails(
        activityType: snapshot.get('ActivityType'),
        activityTitle: snapshot.get('Name'),
        long: 0,
        lat: 0,
        noOfPlayers: 0,
        description: snapshot.get('Description'),
        organiserID: snapshot.get('OrganiserId'),
        aid: snapshot.id);
  }

  Stream<ActivityDetails> getActivityDetails(String id, String type) {
    if (type == 'Sport') {
      return sportsCollection
          .doc(id)
          .snapshots()
          .map(_sportDetailsFromSnapshot);
    } else if (type == 'ESport') {
      return eSportsCollection
          .doc(id)
          .snapshots()
          .map(_eSportDetailsFromSnapshot);
    } else {
      return skillsCollection
          .doc(id)
          .snapshots()
          .map(_skillDetailsFromSnapshot);
    }
  }

  Future<List<ActivityDetails>> activityDetailsForMarkers() async {
    List<ActivityDetails> list = [];
    QuerySnapshot snapshot = await sportsCollection.get();
    snapshot.docs.forEach((document) {
      list.add(ActivityDetails(
        activityType: document.get('ActivityType'),
        activityTitle: document.get('Name'),
        long: document.get('Longitude') ?? '',
        lat: document.get('Latitude') ?? '',
        noOfPlayers: document.get('PlayersReq') ?? '',
        description: document.get('Description'),
        organiserID: document.get('OrganiserId'),
        aid: document.id,
      ));
    });

    return list;
  }

  Future<List<ActivityDetails>> nearestActivityDetailsForMarkers(
      double lat, double long, int range) async {
    List<ActivityDetails> list = [];
    double diffValue = range * 0.005;
    QuerySnapshot snapshot = await sportsCollection
        .where('Latitude', isGreaterThanOrEqualTo: lat - diffValue)
        .where('Latitude', isLessThanOrEqualTo: lat + diffValue)
//        .where('Longitude', isGreaterThanOrEqualTo: long - diffValue)
//        .where('Longitude', isLessThanOrEqualTo: long + diffValue)
        .get();
    snapshot.docs.forEach((document) {
      double l = document.get('Longitude');
      if ((long - diffValue) < l && (long + diffValue) > l) {
        list.add(ActivityDetails(
          activityType: document.get('ActivityType'),
          activityTitle: document.get('Name'),
          long: document.get('Longitude') ?? '',
          lat: document.get('Latitude') ?? '',
          noOfPlayers: document.get('PlayersReq') ?? '',
          description: document.get('Description'),
          organiserID: document.get('OrganiserId'),
          aid: document.id,
        ));
      }
    });

    return list;
  }

  Future addRequest(String aid) async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('ActivityPaticipation')
        .doc(aid)
        .get();
    int req = 0, found = 0;
    if (document.exists) {
      req = document.get('Required');
      found = document.get('Found');
    }
    if(found<req) {
      return await FirebaseFirestore.instance
          .collection('ActivityRequests')
          .doc(aid)
          .collection('requests')
          .doc(uid)
          .set({
        'uid': uid,
        'Accepted': 0,
      });
    }
  }
}
