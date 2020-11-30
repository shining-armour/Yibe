import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/model/message.dart';


class ConversationEssentials {
  String chatRoomId;
  String ownerId;
  List members;
  String ownerAcType;
  String receiverAcType;
  List<Message> messages;

  ConversationEssentials({this.chatRoomId, this.ownerId, this.members, this.ownerAcType, this.receiverAcType, this.messages});

  factory ConversationEssentials.fromFirestore(DocumentSnapshot _snapshot) {
    //print(_snapshot.data());
    var _data = _snapshot.data();
     //print(_data);
    print(_data['messages']);
    List _messages = _data['messages'];
    //print(_messages);
    if (_messages != null) {
      _messages = _messages.map(
            (m) { //print(m);
          return Message(
              type: m['type'] == 'text' ? MessageType.Text : MessageType.Image,
              content: m['content'],
              timestamp: m['timestamp'],
              senderId: m['senderId']);
        },
      ).toList();
    } else {
      _messages = [];
    }
    return ConversationEssentials(
        chatRoomId: _snapshot.id,
        members: _data['members'],
        ownerId: _data['ownerId'],
        messages: _messages);
  }

}

class ConversationSnippet {
  final String chattingWithId;
  final String chatRoomId;
  final String lastMessage;
  final String fullname;
  final String username;
  final String acType;
  final String image;
  final MessageType type;
  final int messagesCount;
  final Timestamp timestamp;
  final String typeOfConversation;
  final String myRelation;

  ConversationSnippet(
      {this.myRelation,
        this.chattingWithId,
        this.chatRoomId,
        this.lastMessage,
        this.messagesCount,
        this.timestamp,
        this.typeOfConversation,        //CAN BE DIRECT OR REQUEST
        this.fullname,
        this.username,
        this.acType,
        this.image,
        this.type});    //CAN BE TEXT OR IMAGE

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();
    print(_data);
    var _messageType = MessageType.Text;
    if (_data['type'] != null) {
      switch (_data['type']) {
        case 'text':
          break;
        case 'image':
          _messageType = MessageType.Image;
          break;
      }
    }
    return ConversationSnippet(
      myRelation: _data['myRelation'],
      chattingWithId: _snapshot.id,
      chatRoomId : _data['chatRoomId'],
      lastMessage: _data['lastMessage'] ?? '',
      messagesCount: _data['messagesCount'],
      timestamp: _data['timestamp'],
      fullname: _data['fullname'],
      username: _data['username'],
      acType: _data['acType'],
      image: _data['image'],
      type: _messageType,
      typeOfConversation: _data['typeOfConversation'],
    );
  }
}