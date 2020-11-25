import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String type;
  String From;
  String username;
  String fullname;
  String profileUrl;
  String To;
  String otherUserRelation;
  Timestamp timestamp;

  NotificationModel({this.type, this.To, this.From, this.username, this.fullname, this.profileUrl, this.otherUserRelation, this.timestamp});

  Map toMap(NotificationModel connectionMap) {
    var data = <String, dynamic>{};
    data['type'] = connectionMap.type;
    data['From'] = connectionMap.From;
    data['username'] = connectionMap.username;
    data['fullname'] = connectionMap.fullname;
    data['profileUrl'] = connectionMap.profileUrl;
    data['To'] = connectionMap.To;
    data['timestamp'] = connectionMap.timestamp;
    data['otherUserRelation'] = connectionMap.otherUserRelation;
    return data;
  }

}

class ConnectionModel{
  String uid;
  String fullname;
  String username;
  String profileUrl;
  String otherUserRelation;
  String myRelation;

  ConnectionModel({this.uid,this.fullname, this.username, this.profileUrl, this.otherUserRelation, this.myRelation});

  Map toMap(ConnectionModel connectionMap) {
    var data = <String, dynamic>{};
    data['uid'] = connectionMap.uid;
    data['username'] = connectionMap.username;
    data['fullname'] = connectionMap.fullname;
    data['profileUrl'] = connectionMap.profileUrl;
    data['otherUserRelation'] = connectionMap.otherUserRelation;
    data['myRelation'] = connectionMap.myRelation;
    return data;
  }

}