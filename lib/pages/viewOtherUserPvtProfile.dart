import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:yibe_final_ui/model/connection.dart';
import 'package:yibe_final_ui/model/post.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/services/snack_bar_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/pages/Conversation.dart';
import 'package:timeago/timeago.dart' as timeago;

//TODO: If not connected, do not show posts
double screenWidth;

class ViewOtherUserPvtProfile extends StatefulWidget {
  final String otherUserUid;
  final String otherUserFullName;
  final String otherUserName;
  final String otherUserProfile;
  final String otherUserBio;
  const ViewOtherUserPvtProfile({this.otherUserUid, this.otherUserFullName, this.otherUserName, this.otherUserProfile, this.otherUserBio});

  @override
  _ViewOtherUserPvtProfileState createState() => _ViewOtherUserPvtProfileState();
}

class _ViewOtherUserPvtProfileState extends State<ViewOtherUserPvtProfile> {
  bool isPost = true;
  bool isMuse = false;
  bool isTimeline = false;
  bool ownPhoto = true;
  bool tagPhoto = false;
  bool museList = true;
  bool museSync = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier ConnectionsCount = ValueNotifier<int>(0);
  ValueNotifier pvtFollowingsCount = ValueNotifier<int>(0);
  static NotificationModel connectionInstance = NotificationModel();
  static bool didConnected = false;
  static bool isConnectionPending = false;

  @override
  void initState() {
    checkIfUserExistsInMyConnection();
    super.initState();
  }

  Future<void> checkIfUserExistsInMyConnection() async {
    await DatabaseService.instance.checkUserExistsInMyConnection(widget.otherUserUid).then((value) => setState((){
      didConnected = value;
      print('Did connection state : '+ didConnected.toString());
    }));
    await DatabaseService.instance.checkIfAlreadySentConnectionRequest(widget.otherUserUid).then((value) => setState((){
      isConnectionPending = value;
      print('Is connection pending : '+ isConnectionPending.toString());
    }));
  }


  Future addUserInMyConnectionAs(context){
    return showDialog(context: context, builder:(context)
    {
      return SimpleDialog(
          title: Text('Add To', textAlign: TextAlign.center,),
          children: <Widget>[
            SimpleDialogOption(
                child: Text('Friend'),
                onPressed: () {
                  addUser('F');
                }
            ),
            SimpleDialogOption(
                child: Text('Close Friend'),
                onPressed: () {
                  addUser('CF');
                }),
            SimpleDialogOption(
                child: Text('Acquaintance'),
                onPressed: () {
                  addUser('AQ');
                }),
            SimpleDialogOption(
                child: Text(
                  'Cancel', style: TextStyle(color: Colors.black, fontSize: 15),),
                onPressed: () => NavigationService.instance.goBack()
            ),
          ]);
    });
  }


  void addUser(type) async {
    setState(() {
      isConnectionPending =true;
    });
    NavigationService.instance.goBack();
    await DatabaseService.instance.getPvtCurrentUserInfo(UniversalVariables.myPvtUid).then((value) => {
    connectionInstance = NotificationModel(
    type: 'Connection Request',
    From: UniversalVariables.myPvtUid,
    fullname: UniversalVariables.myPvtFullName,
    username: UniversalVariables.myPvtUsername,
    profileUrl: value['privateUrl']!=null ? value['privateUrl'] : UniversalVariables.defaultImageUrl,
    otherUserRelation: type,
    To: widget.otherUserUid,
    timestamp: Timestamp.now(),
    ),

   DatabaseService.instance.sendMyConnectionRequest(connectionInstance.toMap(connectionInstance)),
    });
    print(connectionInstance.toMap(connectionInstance));

  }

  Future removeUserFromMyPendingConnection (context){
    return showDialog(context: context, builder:(context)
    {
      return AlertDialog(
          content: Text('Do you really want to withdraw your connection request sent to ${widget.otherUserFullName} ?'),
          actions:[
            FlatButton(
                color: green,
                child: Text('CONTINUE', style: TextStyle(color: white)),
                onPressed: () async {
                  setState(() {
                    isConnectionPending = false;
                  });
                  await DatabaseService.instance.withdrawMyConnectionRequest(widget.otherUserUid);
                  NavigationService.instance.goBack();
                  SnackBarService.instance.showSnackBar(scaffoldKey, 'Your connection request is removed');
                }),
            SizedBox(width: MediaQuery.of(context).size.width/4),
            FlatButton(
                color: red,
                child: Text('NO', style: TextStyle(color: white)),
                onPressed: () => NavigationService.instance.goBack()),
          ]);
    });
  }

  Future removeUserFromMyConnection (context){
    return showDialog(context: context, builder:(context)
    {
      return AlertDialog(
          title: Text('Do you really want to remove ${widget.otherUserFullName} from your connection?'),
          content: Text("${widget.otherUserFullName} won't get notified", textAlign: TextAlign.center),
          actions:[
            FlatButton(
                color: green,
                child: Text('CONTINUE', style: TextStyle(color: white)),
                onPressed: () async {
                  setState(() {
                    didConnected = false;
                    isConnectionPending = false;
                  });
                  DatabaseService.instance.removeUserFromMyConnection(widget.otherUserUid);
                  NavigationService.instance.goBack();
                  SnackBarService.instance.showSnackBar(scaffoldKey, '${widget.otherUserName} is removed from your connection');
                }),
            SizedBox(width: MediaQuery.of(context).size.width/4),
            FlatButton(
                color: red,
                child: Text('NO', style: TextStyle(color: white)),
                onPressed: () => NavigationService.instance.goBack()),
          ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(widget.otherUserProfile==null ? UniversalVariables.defaultImageUrl : widget.otherUserProfile),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(children: [
                    //SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.otherUserFullName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '@'+widget.otherUserName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          widget.otherUserBio,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),

              SizedBox(height: 8.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  children: [
                    FutureBuilder(
                        future: DatabaseService.instance
                            .getConnectionCountOfAUser(
                            widget.otherUserUid),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text(
                                '0',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              }
                              break;
                            default:
                              if (snapshot.hasError) {
                                return Text('Error occured');
                              }
                          }
                        }),
                    Text(
                      'Incircle',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 70),
                Column(
                  children: [
                    FutureBuilder(
                        future: DatabaseService.instance.getPvtFollowingCountOfAUser(widget.otherUserUid),
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text(
                                '0',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              }
                              break;
                            default:
                              if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}');
                              }
                          }
                        }),
                    Text(
                      'Following',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 12),
              Consumer<AcType>(
                builder:(context,model,child)=> didConnected ? Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 140.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                         color: green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'Connected',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      onTap: (){removeUserFromMyConnection(context);},
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap:() {
                          DatabaseService.instance.createOrGetConversation(widget.otherUserUid, 'Private', 'Private', (String chatRoomId) {
                            print(chatRoomId + 'In Future on Success');
                            return NavigationService.instance
                                .pushTo(MaterialPageRoute(
                                builder: (_) => ConversationPage(
                                    navigatedFromPrivateAc: true,
                                    chatRoomId: chatRoomId,
                                    otherUserUid: widget.otherUserUid,
                                    otherUserFullName: widget.otherUserFullName,
                                    otherUserName: widget.otherUserName,
                                    otherUserProfileUrl: widget.otherUserProfile)));
                          }
                          );} ,//TODO: Open chatscreen
                      child: Container(
                        width: 140.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'Message',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                              color: black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ): GestureDetector(
                  onTap: (){ isConnectionPending ? removeUserFromMyPendingConnection(context):addUserInMyConnectionAs(context);},
                  child: Container(
                    width: 350,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: isConnectionPending ? yellow :red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(isConnectionPending ? 'Pending': 'Connect',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          color: white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height:
                  12.0), // now onwards diff for private and professional
              Column(
                children: [
                  Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Color(0xFFFAFAFA),
                        boxShadow: [
                          new BoxShadow(
                              color: Color(0x19000000),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 2.0)
                        ]),
                    //color: Colors.white,
                    //elevation: 5.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 15.0, top: 3.0, bottom: 3.0),
                      child: Container(
                        //color: Colors.white,
                        width: screenWidth,
                        height: 50.0,

                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPost = true;
                                  isMuse = false;
                                  isTimeline = false;
                                });
                              },
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color:
                                  isPost ? primaryColor : Color(0xFFA7A7A7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMuse = true;
                                  isPost = false;
                                  isTimeline = false;
                                });
                              },
                              child: Text(
                                'Muse',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color:
                                  isMuse ? primaryColor : Color(0xFFA7A7A7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       isTimeline = true;
                            //       isMuse = false;
                            //       isPost = false;
                            //     });
                            //   },
                            //   child: Text(
                            //     'Timeline',
                            //     style: TextStyle(
                            //       fontFamily: 'Poppins',
                            //       fontSize: 20.0,
                            //       color: isTimeline
                            //           ? green
                            //           : Color(0xFFA7A7A7),
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  isPost
                      ? Container(
                    // for post
                    width: screenWidth,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 3.0,
                            bottom: 3.0),
                        child: Container(
                          width: screenWidth,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ownPhoto = true;
                                    tagPhoto = false;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/posts.svg',
                                  width: 25.0,
                                  height: 25.0,
                                  color: ownPhoto
                                      ? Colors.black
                                      : Color(0xFFA7A7A7),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ownPhoto = false;
                                    tagPhoto = true;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/tag.svg',
                                  width: 25.0,
                                  height: 25.0,
                                  color: tagPhoto
                                      ? Colors.black
                                      : Color(0xFFA7A7A7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: ownPhoto
                            ? Container(
                          width: screenWidth,
                          height: 300,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: DatabaseService.instance.getAllPvtPostImageofOtherUser(widget.otherUserUid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  print('in waiting for posts');
                                  return Center(
                                    child:
                                    CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.data == null ||
                                    snapshot.data.docs.length ==
                                        0) {
                                  return Center(
                                      child: Container(
                                          child: Text(
                                              'No posts yet')));
                                }

                                var postSnippet =
                                    snapshot.data.docs;
                                print(postSnippet);
                                return GridView.builder(
                                    itemCount: postSnippet.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                postSnippet[i]
                                                    .data()[
                                                'postUrl']),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      );
                                    });
                              }),
                        )
                            : Center(child: Text('tag photoes')),
                      ),
                    ]),
                  )
                      : isMuse
                      ? Container(
                    // for muse
                    width: screenWidth,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 3.0,
                            bottom: 3.0),
                        child: Container(
                          width: screenWidth,
                          padding: EdgeInsets.only(left: 16.0),
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    museList = true;
                                    museSync = false;
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/muse_list.svg',
                                  width: 21.0,
                                  height: 16.0,
                                  color: museList
                                      ? Colors.black
                                      : Color(0xFFA7A7A7),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       museList = false;
                              //       museSync = true;
                              //     });
                              //   },
                              //   child: SvgPicture.asset(
                              //     'assets/images/muse_sync.svg',
                              //     width: 25.0,
                              //     height: 17.0,
                              //     color: museSync
                              //         ? Colors.black
                              //         : Color(0xFFA7A7A7),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: museList
                            ? Container(
                            width: screenWidth,
                            height: 300,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: DatabaseService.instance.getAllPvtPostMuseofOtherUser(widget.otherUserUid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print('in waiting for muse');
                                    return Center(
                                      child:
                                      CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.data == null ||
                                      snapshot.data.docs.length ==
                                          0) {
                                    return Center(
                                        child: Container(
                                            child: Text(
                                                'No muse yet')));
                                  }

                                  var museSnippet =
                                      snapshot.data.docs;
                                  print(museSnippet);
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                      museSnippet.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              bottom: 5.0),
                                          width: screenWidth,
                                          padding:
                                          EdgeInsets.all(3.0),
                                          decoration:
                                          BoxDecoration(
                                            border: Border.all(
                                                color: Color(
                                                    0xFFDADADA)),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              ListTile(
                                                leading:
                                                Container(
                                                  width: 45.0,
                                                  height: 45.0,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        5.0),
                                                    image:
                                                    DecorationImage(
                                                      image: NetworkImage(widget.otherUserProfile),
                                                      fit: BoxFit
                                                          .fill,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  '@'+widget.otherUserName,
                                                  style:
                                                  TextStyle(
                                                    fontFamily:
                                                    'Poppins',
                                                    fontSize:
                                                    14.0,
                                                    color: Colors
                                                        .black,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  timeago.format(DateTime.tryParse(
                                                      museSnippet[i].data()['timestamp'].toDate().toString())).toString(),
                                                  style:
                                                  TextStyle(
                                                    fontFamily:
                                                    'Poppins',
                                                    fontSize:
                                                    14.0,
                                                    color: Color(
                                                        0xFFA7A7A7),
                                                  ),
                                                ),
                                                trailing: Icon(Icons
                                                    .more_vert),
                                              ),
                                              Padding(
                                                padding: EdgeInsets
                                                    .only(
                                                    left:
                                                    11.0),
                                                child: Text(
                                                  museSnippet[i].data()['postText'],
                                                  style:
                                                  TextStyle(
                                                    fontFamily:
                                                    'Poppins',
                                                    fontSize:
                                                    18.0,
                                                    color: Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Spacer(),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .favorite,
                                                      color: Colors
                                                          .red,
                                                    ),
                                                    onPressed:
                                                        () {},
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }))
                            : SizedBox(child: Text('Muse part')),
                      ),
                    ]),
                  )
                      : Container(
                    margin: EdgeInsets.only(top: 5.0),
                    width: screenWidth,
                    child: ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: green,
                                    child: CircleAvatar(
                                      radius: 28.0,
                                      backgroundColor: Colors.white,
                                      child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 25.0,
                                                color: green,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              'oct',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10.0,
                                                color: green,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  SizedBox(width: 15.0),
                                  Text(
                                    'Watched some movie',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              index != 4
                                  ? Container(
                                margin:
                                EdgeInsets.only(left: 28.0),
                                width: 3.0,
                                height: 8.0,
                                color: Colors.grey,
                              )
                                  : SizedBox(),
                            ],
                          );
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}