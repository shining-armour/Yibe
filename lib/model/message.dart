import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  Text,
  Image,
}

class Message {
  String senderId;
  String content;
  Timestamp timestamp;
  MessageType type;

  Message({this.senderId, this.content, this.timestamp, this.type});
}
