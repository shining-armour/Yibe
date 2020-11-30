import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:yibe_final_ui/pages/Conversation.dart';
import 'package:yibe_final_ui/model/conversation.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/model/message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yibe_final_ui/services/navigation_service.dart';


class Messages extends StatefulWidget {
//  static final routeName = "/Message";

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool checkBoxesEnabled = false;
  bool checkBoxActive = false;

  var activeTabInList = 0;
  bool _isPrivate = true;
  bool _isStared = false;
  Color _green = Color(0xFF0CB5BB);
  Color _blue = Color(0xFF424283);
  bool didClickedOnRequest = false;
  bool isConfirmed =false;
  //List<Map> priStar = [];
  //List<Map> proStar = [];
  List list2 = ["Friends", "Close Friends", "Acquaintance", "Followings"];
  //List<Map> temp = [];
  Stream<List<ConversationSnippet>> CFMsgStream;
  Stream<List<ConversationSnippet>> FMsgStream;
  Stream<List<ConversationSnippet>> AQMsgStream;
  Stream<List<ConversationSnippet>> followingMsgStream;
  Stream<List<ConversationSnippet>> profDirectMsgStream;
  Stream<List<ConversationSnippet>> profRequestMsgStream;

  @override
  void initState() {
    super.initState();
    CFMsgStream = DatabaseService.instance.getCFUserConversations();
    FMsgStream = DatabaseService.instance.getFUserConversations();
    AQMsgStream = DatabaseService.instance.getAQUserConversations();
    followingMsgStream = DatabaseService.instance.getFollowingUserConversations();
    profDirectMsgStream = DatabaseService.instance.getProfUserDirectConversations();
    profRequestMsgStream = DatabaseService.instance.getProfUserRequestConversations();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // if (details.delta.dx > 0) {
        //   Navigator.of(context).pop();
        // }
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(46.0),
            child: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text(
                "Messages",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                FlatButton(
                  child: !checkBoxesEnabled ? Text('Add Chats to Selective') : Text('Confirm'),
                  color: primaryColor,
                  onPressed: () {
                    setState(() {
                      checkBoxesEnabled = !checkBoxesEnabled;
                    });
                  },
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 12, right: 15, left: 15),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFFAFAFA),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPrivate = !_isPrivate;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    border: Border.all(
                                        color: Color(0xFFFAFAFA), width: 2),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Private",
                                  style: TextStyle(
                                      color: _isPrivate ? _green : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            )),
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPrivate = !_isPrivate;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    border: Border.all(
                                        color: Color(0xFFFAFAFA), width: 2),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Professional",
                                  style: TextStyle(
                                      color: _isPrivate ? Colors.grey : _blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 15),
                              decoration: new InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isPrivate ? _green : _blue,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isPrivate ? _green : _blue,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Search',
                              ),
                            )),

                        //=================================================================================================================
                        SizedBox(
                          width: 10,
                        ),

                        Container(
                          height: 24,
                          // width: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _isPrivate ? _green : _blue,
                                width: 2,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          //  width: screenWidth,
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isStared = !_isStared;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: _isPrivate
                                          ? !_isStared
                                          ? _green
                                          : Colors.white
                                          : !_isStared
                                          ? _blue
                                          : Colors.white,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                        color: _isPrivate
                                            ? !_isStared
                                            ? Colors.white
                                            : _isPrivate
                                            ? _green
                                            : _blue
                                            : !_isStared
                                            ? Colors.white
                                            : _isPrivate
                                            ? _green
                                            : _blue,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isStared = !_isStared;
                                  });
                                },
                                child: Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: _isPrivate
                                            ? _isStared
                                            ? _green
                                            : Colors.white
                                            : _isStared
                                            ? _blue
                                            : Colors.white,
                                        // border: Border.all(
                                        //     color:
                                        //         _isPrivate ? Colors.white : _blue,
                                        //     width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Icon(Icons.star,
                                        size: 20,
                                        color: _isPrivate
                                            ? _isStared
                                            ? Colors.white
                                            : _isPrivate
                                            ? _green
                                            : _blue
                                            : _isStared
                                            ? Colors.white
                                            : _isPrivate
                                            ? _green
                                            : _blue)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isPrivate ? SizedBox(height: 12) : Container(),
                  _isPrivate
                      ? Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: list2.length,
                        itemBuilder: (context, index) {
                          var item = list2[index];
                          return GestureDetector(
                            //   color: Colors.red,
                              onTap: () {
                                setState(() {
                                  activeTabInList = index;
                                  setState(() {});

                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //   duration: Duration(milliseconds: 200),
                                  //   content: Text(item)));
//                                        isVisible = !isVisible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 16.0),
                                child: Container(
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.07,
                                  child: Column(
                                    children: [
                                      Text(
                                        item,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            activeTabInList == index
                                                ? Color(0xff008294)
                                                : Colors.grey),
                                      ),
                                      activeTabInList == index
                                          ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                          BorderRadius.circular(
                                              20.0),
                                        ),
                                        width: index == 0
                                            ? MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.2
                                            : MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.3,
                                        height: 1,
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  )
                      : GestureDetector(
                    onTap: ()=> {setState((){
                      didClickedOnRequest = ! didClickedOnRequest;
                    })},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(didClickedOnRequest ? 'Check Direct Messages' : 'Check Request Messages', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //  _isPrivate?

//
//                                   ListView.builder(
//                                 //  key: ObjectKey(list2[0]),
//                                // controller: _controller,
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemCount: list2.length,
//                                 itemBuilder: (context, index) {
//                                   var item = list2[index];
// //                                   return FlatButton(
// //                                       onPressed: () {
// //                                         setState(() {
// //                                           Scaffold.of(context).showSnackBar(SnackBar(content: item));
// // //                                        isVisible = !isVisible;
// //                                         });
// //                                       },
// //                                       child: Text(item));
//                                 })
//                          :Container(),

                  //  SizedBox(height: 15),
                  _isPrivate ? activeTabInList==0 ? FMsgList() : activeTabInList==1 ? CFMsgList() : activeTabInList==2 ? AQMsgList() : activeTabInList==3 ? followingMsgList() : Container() : didClickedOnRequest ? ProfRequestMsgList() : ProfDirectMsgList(),
                ],
              ),
            ),
          )),
    );
  }

  Widget CFMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: CFMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance
                              .collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Private_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget FMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: FMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance
                              .collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Private_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget AQMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: AQMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }
              //TODO: Check whether Pvt-Prof conv are deleted if no messages are sent
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance
                              .collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Private_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }


  Widget followingMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: followingMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance
                              .collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Private_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }


  Widget ProfDirectMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: profDirectMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance.collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Professional_Ac').doc(UniversalVariables.myProfUid).collection('Prof_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget ProfRequestMsgList(){
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: profRequestMsgStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of CF');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No msg yet')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No message yet')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance.collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Professional_Ac').doc(UniversalVariables.myProfUid).collection('Prof_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,)
                                : conversationSnippet[i].image!=null ? ConversationSnippetListTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,):
                            ConversationSnippetListTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl,checkBoxesEnabled: checkBoxesEnabled,checkBoxActive: checkBoxActive,),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}








class ConversationSnippetListTile extends StatefulWidget {

  ConversationSnippet snippet;
  String url;
  bool checkBoxesEnabled;
  bool checkBoxActive;

  ConversationSnippetListTile(
      {this.snippet, this.url, this.checkBoxActive, this.checkBoxesEnabled,});

  @override
  _ConversationSnippetListTileState createState() => _ConversationSnippetListTileState();
}

class _ConversationSnippetListTileState extends State<ConversationSnippetListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.snippet.acType=='Private' ?
        NavigationService.instance.pushTo(MaterialPageRoute(
            builder: (context) => ConversationPage(
              navigatedFromPrivateAc: true,
              otherUserFullName: widget.snippet.fullname,
              otherUserName: widget.snippet.username,
              otherUserProfileUrl: widget.url,
              otherUserUid: widget.snippet.chattingWithId,
              chatRoomId: widget.snippet.chatRoomId,
              typeOfConversation: widget.snippet.typeOfConversation,
            ))) :
        NavigationService.instance.pushTo(MaterialPageRoute(
            builder: (context) => ConversationPage(
              navigatedFromPrivateAc: false,
              otherUserFullName: widget.snippet.fullname,
              otherUserName: widget.snippet.username,
              otherUserProfileUrl: widget.url,
              otherUserUid: widget.snippet.chattingWithId,
              chatRoomId: widget.snippet.chatRoomId,
              typeOfConversation: widget.snippet.typeOfConversation,
            )));

      },
      title: Text(widget.snippet.fullname),
      subtitle: Text(widget.snippet.type == MessageType.Text
          ? widget.snippet.lastMessage
          : 'Attachment: Image'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.url),
      ),
      trailing: widget.checkBoxesEnabled
          ? Checkbox(
          value: widget.checkBoxActive,
          activeColor: green,
          onChanged: (bool newValue) async {
            setState(() {
              widget.checkBoxActive = newValue;
            });
            if (widget.checkBoxActive) {
              widget.snippet.acType=='Private' ? DatabaseService.instance.addThisPvtChatToSelective(widget.snippet.chattingWithId) : DatabaseService.instance.addThisProfChatToSelective(widget.snippet.chattingWithId);
            } else {
              widget.snippet.acType=='Private' ? DatabaseService.instance.removeThisPvtChatFromSelective(widget.snippet.chattingWithId) : DatabaseService.instance.removeThisProfChatFromSelective(widget.snippet.chattingWithId);
            }
          })
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'Last Message',
            style: TextStyle(fontSize: 15),
          ),
          widget.snippet.timestamp != null
              ? Text(timeago
              .format(DateTime.tryParse(
              widget.snippet.timestamp.toDate().toString()))
              .toString())
              : Text('timestamp null'),
        ],
      ),
    );
  }
}

