import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/messaging_service.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/model/conversation.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/services/storage_service.dart';
import 'package:yibe_final_ui/services/media_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationPage extends StatefulWidget {
  final bool navigatedFromPrivateAc;
  final String chatRoomId;
  final String otherUserUid;
  final String otherUserFullName;
  final String otherUserName;
  final String otherUserProfileUrl;
  final String typeOfConversation;

  ConversationPage(
      {this.navigatedFromPrivateAc, this.otherUserName, this.chatRoomId, this.otherUserUid, this.otherUserFullName, this.otherUserProfileUrl, this.typeOfConversation});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController messageEditingController = TextEditingController();
  String currentMsg;
  static double _deviceHeight;
  static double _deviceWidth;
  static String _imageUrl;
  File _mediaImage;


  @override
  void initState() {
    super.initState();
    MessagingService.instance.sendNotification();
    //MessagingService.instance.sendNotification();
    print(widget.navigatedFromPrivateAc);
    print(widget.otherUserName);
    print(widget.otherUserUid);
    print(widget.chatRoomId);
    //print(widget.navigatedFromPrivateAc);
    widget.typeOfConversation == 'Request' ? _requestPermission() : null;
  }

  ScrollController controller = ScrollController();

  void _requestPermission() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(widget.otherUserFullName +
                    ' wants to start a conversation with you.'),
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text('Allow'),
                        color: Colors.green,
                        onPressed: () async {
                          widget.navigatedFromPrivateAc
                              ? await DatabaseService.instance.movePvtRMToDM(
                              widget.otherUserUid)
                              : await DatabaseService.instance.moveProfRMToDM(
                              widget.otherUserUid);
                          NavigationService.instance.goBack();
                        },
                      ),
                      FlatButton(
                          child: Text('Deny'),
                          color: Colors.red,
                          onPressed: () {
                            NavigationService.instance.goBack();
                            NavigationService.instance.goBack();
                          }
                      ),
                    ]),
              )
      );
    });
  }

  void MediabottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.add_a_photo, color: primaryColor),
                    hoverColor: primaryColor,
                    title: Text('Camera'),
                    onTap: () async {
                      File _image = await MediaService.instance.getCamImage();
                      setState(() {
                        _mediaImage = _image;
                      });
                      sendImageToCloud();
                    }
                ),
                ListTile(
                    leading: Icon(
                      Icons.add_photo_alternate, color: primaryColor,),
                    hoverColor: primaryColor,
                    title: Text('Gallery'),
                    onTap: () async {
                      File _image = await MediaService.instance
                          .getGalleryImage();
                      setState(() {
                        _mediaImage = _image;
                      });
                      sendImageToCloud();
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  void sendImageToCloud() async {
    await StorageService.instance.uploadMessageTypeImage(
        _mediaImage, UniversalVariables.myProfUid).then((val) =>
        setState(() {
          _imageUrl = val;
          if (_imageUrl != null) {
            DatabaseService.instance.sendMessage(
              widget.chatRoomId, Message(
                content: _imageUrl,
                timestamp: Timestamp.now(),
                senderId: widget.navigatedFromPrivateAc ? UniversalVariables
                    .myPvtUid : UniversalVariables.myProfUid,
                type: MessageType.Image),
            );
          }
          else {
            print('Empty image');
          }
        })).whenComplete(() =>
        print('Image sent to cloud firestore successfully'));
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            actions: <Widget>[
              Container(
                color: Colors.white,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => NavigationService.instance.goBack(),
                      child: SvgPicture.asset(
                        'assets/images/back_btn.svg',
                        // width: 31.0,
                        height: 16.0,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.otherUserProfileUrl),
                          radius: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        //   Image.asset(widget.image),
                        Text(
                          widget.otherUserFullName,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        )
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      // onLongPress: () {
                      //   widget.hiberPopUp(true);
                      // },
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return Messages();
                        // }));
                      },
                      child: SizedBox(
                        height: 30,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              )
            ],
          ),
          body: Container(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    children: [
                      chats(),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4.0,
                          ),
                        ],

                        color: Colors.white,
                        // border: Border.all(
                        //   color: Color(0xff008294),
                        //   width: 1.0,
                        // ),

                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              "assets/images/camera.svg",
                              width: 30,
                              height: 50,
                            ),
                            onTap: () => MediabottomSheet(context),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              controller: messageEditingController,
                              onChanged: (String msg){
                                currentMsg=msg;
                              },
                              // style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  hintText: "Message ...",
                                  hintStyle: TextStyle(
                                    color: Color(0xFFA7A7A7),
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                              child: Container(child: Icon(Icons.send),
                                width: 30,
                                height: 50,
                              ),
                              onTap: ()async{
                                if(currentMsg.trim().isEmpty)
                                {print('Message is Empty');
                                } else{
                                  await DatabaseService.instance.sendMessage(
                                    widget.chatRoomId, Message(
                                      content: currentMsg.toString(),
                                      timestamp: Timestamp.now(),
                                      senderId: widget.navigatedFromPrivateAc ? UniversalVariables.myPvtUid : UniversalVariables.myProfUid,
                                      type: MessageType.Text),
                                  );
                                }}
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }


  Widget _messageListViewChild(bool _isOwnMessage, Message _message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
        _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          _message.type == MessageType.Text
              ? _textMessageBubble(
              _isOwnMessage, _message.content, _message.timestamp)
              : _imageMessageBubble(
              _isOwnMessage, _message.content, _message.timestamp),
        ],
      ),
    );
  }

  Widget _textMessageBubble(bool _isOwnMessage, String _message,
      Timestamp _timestamp) {
    return Container(
      height: _deviceHeight * 0.08 + (_message.length / 20 * 5.0),
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: _isOwnMessage ?
        BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20))
            : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)),
        color: _isOwnMessage ? widget.navigatedFromPrivateAc
            ? Color(0xff0CB5BB)
            : Color(0xFF908EE1) : Color(0xFFDBDBDB),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(_message),
          Text(
            timeago.format(DateTime.tryParse(_timestamp.toDate().toString()))
                .toString(),
            style: TextStyle(color: grey),
          ),
        ],
      ),
    );
  }

  Widget _imageMessageBubble(bool _isOwnMessage, String _imageUrl,
      Timestamp _timestamp) {
    DecorationImage _image =
    DecorationImage(
        image: _imageUrl != null ? NetworkImage(_imageUrl) : UniversalVariables
            .loadingImage, fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: _isOwnMessage ?
        BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20))
            : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)),
        color: _isOwnMessage ? widget.navigatedFromPrivateAc
            ? Color(0xff0CB5BB)
            : Color(0xFF908EE1) : Color(0xFFDBDBDB),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: _deviceHeight * 0.30,
            width: _deviceWidth * 0.40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          Text(
            timeago.format(_timestamp.toDate()),
            style: TextStyle(color: grey),
          ),
        ],
      ),
    );
  }

  Widget chats() {
    return Flexible(
        child: StreamBuilder<ConversationEssentials>(
            stream: DatabaseService.instance.getConversation(widget.chatRoomId),
            // ignore: missing_return
            builder: (context, snapshot) {
              Timer(
                Duration(milliseconds: 50),
                    () =>
                    controller.jumpTo(controller.position.maxScrollExtent),
              );
              if (snapshot.hasData) {
                var conversationEss = snapshot.data;
                print(conversationEss.messages.length);
                if (conversationEss != null) {
                  return ListView.builder(
                    itemCount: conversationEss.messages.length,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, i) {
                      var message = conversationEss.messages[i];
                      bool _isOwnMessage = widget.navigatedFromPrivateAc
                          ? message.senderId == UniversalVariables.myPvtUid
                          : message.senderId == UniversalVariables.myProfUid;
                      return _messageListViewChild(_isOwnMessage, message);
                    },
                    controller: controller,
                  );
                }
              } else {
                return Center(child: Container(child: Text('No messages')));
              }
            }));
  }
}

/*class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool isPersonal;
  final senderImage;
  const MessageTile({
    Key key,
    this.message,
    this.sendByMe,
    this.isPersonal,
    this.senderImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 0, bottom: 8, left: sendByMe ? 0 : 8, right: sendByMe ? 8 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          sendByMe
              ? Spacer()
              : CircleAvatar(
                  backgroundImage: senderImage,
                  radius: 20,
                ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
                minWidth: 0),
            child: Container(
              margin: sendByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(left: 5, right: 30),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 8),
              decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))
                      : BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: sendByMe
                        ? isPersonal
                            ? [Color(0xff0CB5BB), Color(0xff0CB5BB)]
                            : [Color(0xFF908EE1), Color(0xFF908EE1)]
                        : [Color(0xFFDBDBDB), Color(0xFFDBDBDB)],
                  )),
              child: sendByMe
                  ? Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300))
                  : Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
            ),
          ),
        ],
      ),
    );
  }
}*/
