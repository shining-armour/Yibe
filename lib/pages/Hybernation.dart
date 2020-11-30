import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/pages/Conversation.dart';
import 'package:yibe_final_ui/model/conversation.dart';
import 'package:yibe_final_ui/utils/helper_functions.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yibe_final_ui/model/message.dart';
import 'package:yibe_final_ui/services/messaging_service.dart';

final Color privatePrimary = Color(0xFF0CB5BB);
final Color privateSecondary = Color(0xFF157F83);
final Color publicPrimary = Color(0xFF7280FF);
final Color publicSecondary = Color(0xFF424283);

var activeTabInList = 0;
bool _isPrivate = true;
bool _isStarred = true;

List<Map> privateAll = [];
List<Map> privateStar = [];
List<Map> professionalAll = [];
List<Map> professionalStar = [];
List contentFilteration = [
  "Friends",
  "Close Friends",
  "Acquaintance",
  "Activities"
];
List<Map> temp = [];

class Hybernation extends StatefulWidget {
  @override
  _HybernationState createState() => _HybernationState();
}

class _HybernationState extends State<Hybernation> {
  bool isHibernation;
  Stream<List<ConversationSnippet>> pvtSelectiveStream;
  Stream<List<ConversationSnippet>> profSelectiveStream;

  @override
  void initState() {
    super.initState();
   getSelectiveConversations();
    MessagingService.instance.sendNotification();
  }

  void getSelectiveConversations(){
    pvtSelectiveStream = DatabaseService.instance.getPvtSelectiveConversations();
    profSelectiveStream = DatabaseService.instance.getProfSelectiveConversations();
  }


  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(
            'Yibe',
            style: TextStyle(color: privatePrimary),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  _showOptionsSheet();
                },
                child: Icon(Icons.more_vert, size: 28, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 30,
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
                          child: Text(
                            "Private",
                            style: TextStyle(
                                color: _isPrivate ? privatePrimary : Colors.grey,
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
                          child: Text(
                            "Professional",
                            style: TextStyle(
                                color: _isPrivate ? Colors.grey : publicPrimary,
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
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  _isPrivate ? privatePrimary : publicPrimary,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  _isPrivate ? privatePrimary : publicPrimary,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Search',
                        ),
                      )),

//=============================================================================================================================================
                  SizedBox(
                    width: 10,
                  ),

                  Container(
                      height: 24,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: _isPrivate
                              ? _isStarred
                              ? privatePrimary
                              : Colors.white
                              : _isStarred
                              ? publicPrimary
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Icon(Icons.star,
                          size: 20,
                          color: _isPrivate
                              ? _isStarred
                              ? Colors.white
                              : _isPrivate
                              ? privatePrimary
                              : publicPrimary
                              : _isStarred
                              ? Colors.white
                              : _isPrivate
                              ? privatePrimary
                              : publicPrimary)),
                ],
              ),
            ),
            _isPrivate ? SizedBox(height: 12) : Container(),
          _isPrivate ? PvtSelectiveMsgList() : ProfSelectiveMsgList()
          /*  _isPrivate
                ? Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: contentFilteration.length,
                  itemBuilder: (context, index) {
                    var item = contentFilteration[index];
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeTabInList = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 16.0),
                          child: Container(
                            height:
                            MediaQuery.of(context).size.height * 0.07,
                            child: Column(
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: activeTabInList == index
                                          ? privateSecondary
                                          : Colors.grey),
                                ),
                                activeTabInList == index
                                    ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
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
                : Container(),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _isPrivate
                    ? _isStarred
                    ? privateStar.length
                    : privateAll.length
                    : _isStarred
                    ? professionalStar.length
                    : professionalAll.length,
                itemBuilder: (context, index) {
                  if (_isPrivate) {
                    if (_isStarred)
                      temp = privateStar;
                    else
                      temp = privateAll;
                  } else {
                    if (_isStarred)
                      temp = professionalStar;
                    else
                      temp = professionalAll;
                  }

                  return GestureDetector(
                    onTap: () {
                      /*Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Conversation(
                              name: temp[index]["name"],
                              image: temp[index]["image"],
                              isPersonal: _isPrivate,
                            );
                          }));*/
                    },
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(temp[index]["image"]),
                            radius: 30,
                          ),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  temp[index]["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  temp[index]["time"],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ]),
                          subtitle: Text(temp[index]["msg"], maxLines: 2),
                        ),
                        Divider(
                          height: 16,
                        )
                      ],
                    ),
                  );
                })*/
          ],
        ),
      ),
    );
  }

  Widget PvtSelectiveMsgList() {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: pvtSelectiveStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of pvt selective');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No pvt conversations are added to selective')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No pvt conversations are added to selective')));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversationSnippet.length,
                      itemBuilder: (context, i) {
                        if (conversationSnippet[i].messagesCount == 0) {
                          FirebaseFirestore.instance.collection('All_Chats').doc(conversationSnippet[i].chatRoomId).delete();
                          FirebaseFirestore.instance.collection('Users').doc(UniversalVariables.myPvtUid).collection('Private_Chats').doc(conversationSnippet[i].chattingWithId).delete();
                        }
                        return Column(
                          children: [
                            conversationSnippet[i].chattingWithId.contains('-')
                                ? ConversationSnippetTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image)
                                : conversationSnippet[i].image!=null ? ConversationSnippetTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image):
                            ConversationSnippetTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl),
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

  Widget ProfSelectiveMsgList() {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<ConversationSnippet>>(
          stream: profSelectiveStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of prof selective');
              return Center(child: Container(child: CircularProgressIndicator(),));
            }

            if (snapshot.data == null ) {
              return Center(child: Container(child: Text('No prof Conversations are added to selective')));
            }

            if (snapshot.hasData) {
              var conversationSnippet = snapshot.data;

              if (conversationSnippet.isEmpty) {
                return Center(
                    child: Container(child: Text('No prof Conversations are added to selective')));
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
                                ? ConversationSnippetTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image)
                                : conversationSnippet[i].image!=null ? ConversationSnippetTile(snippet: conversationSnippet[i], url:conversationSnippet[i].image):
                            ConversationSnippetTile(snippet: conversationSnippet[i], url:UniversalVariables.defaultImageUrl),
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

  void _showOptionsSheet() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.grey,
            //height: 180,
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                      title: Text('Exit Hybernation Mode',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('pageHandler');
                        HelperFunction.saveHibernationModeAsSharedPreference(false);
                      }),
                  ListTile(
                    title: Text('Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    title: Text('Manage Money',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    title: Text('Update Resume',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

}

class ConversationSnippetTile extends StatefulWidget {

  ConversationSnippet snippet;
  String url;

  ConversationSnippetTile({this.snippet, this.url});

  @override
  _ConversationSnippetTileState createState() => _ConversationSnippetTileState();
}

class _ConversationSnippetTileState extends State<ConversationSnippetTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.snippet.chattingWithId),
      onDismissed: (direction){
        widget.snippet.acType=='Private' ? DatabaseService.instance.removeThisPvtChatFromSelective(widget.snippet.chattingWithId) : DatabaseService.instance.removeThisProfChatFromSelective(widget.snippet.chattingWithId);
      },
      child: ListTile(
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
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.snippet.fullname),
              Text(timeago.format(DateTime.tryParse(
                  widget.snippet.timestamp.toDate().toString()))
                  .toString()), ]),
        subtitle: Text(widget.snippet.type == MessageType.Text ? widget.snippet.lastMessage.length > 35 ? widget.snippet.lastMessage.substring(0,35)+'...' : widget.snippet.lastMessage : 'Attachment: Image'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.url),
        ),
      ),
    );
  }
}

