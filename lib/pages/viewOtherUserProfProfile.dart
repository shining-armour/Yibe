import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:yibe_final_ui/model/post.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/model/connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/pages/Conversation.dart';
import 'package:timeago/timeago.dart' as timeago;

double screenWidth;

class ViewOtherUserProfProfile extends StatefulWidget {
  final bool navigatedFromPrivateAc;
  final String otherUserPvtUid;
  final String otherUserProfUid;
  final String otherUserBusinessName;
  final String otherUserName;
  final String otherUserProfile;
  final String otherUserBio;
  const ViewOtherUserProfProfile(
      {this.navigatedFromPrivateAc,
      this.otherUserPvtUid,
      this.otherUserProfUid,
      this.otherUserBusinessName,
      this.otherUserName,
      this.otherUserProfile,
      this.otherUserBio});

  @override
  _ViewOtherUserProfProfileState createState() =>
      _ViewOtherUserProfProfileState();
}

class _ViewOtherUserProfProfileState extends State<ViewOtherUserProfProfile> {
  ValueNotifier followersCount = ValueNotifier<int>(0);
  ValueNotifier followingsCount = ValueNotifier<int>(0);
  static NotificationModel followerInstance = NotificationModel();
  static bool didFollow = false;
  bool isPost = true;
  bool isMuse = false;
  bool isTimeline = false;
  bool ownPhoto = true;
  bool tagPhoto = false;
  bool museList = true;
  bool museSync = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print(widget.navigatedFromPrivateAc);
    widget.navigatedFromPrivateAc
        ? checkIfUserExistInMyPvtFollowing()
        : checkIfUserExistInMyProfFollowing();
    super.initState();
  }

  void checkIfUserExistInMyPvtFollowing() {
    DatabaseService.instance
        .checkUserExistsInMyPvtFollowing(widget.otherUserProfUid)
        .then((value) => setState(() {
              didFollow = value;
            }));
  }

  void checkIfUserExistInMyProfFollowing() {
    DatabaseService.instance
        .checkUserExistsInMyProfFollowing(widget.otherUserProfUid)
        .then((value) => setState(() {
              didFollow = value;
            }));
  }

  void sendFollowerNotification() {
    print('In send Follower notification');
    if (widget.navigatedFromPrivateAc) {
      DatabaseService.instance.getPvtCurrentUserInfo(UniversalVariables.myPvtUid).then((value) {
        followerInstance = NotificationModel(
          type: 'Private Follower',
          From: UniversalVariables.myPvtUid,
          fullname: UniversalVariables.myPvtFullName,
          username: UniversalVariables.myPvtUsername,
          profileUrl: value['privateUrl']!=null ? value['privateUrl'] : UniversalVariables.defaultImageUrl,
          otherUserRelation: 'Following',
          To: widget.otherUserProfUid,
          timestamp: Timestamp.now(),
        );
        print(followerInstance.toString());
        DatabaseService.instance.sendFollowingConfirmation(followerInstance.toMap(followerInstance), widget.otherUserPvtUid);
      });
    } else {
      DatabaseService.instance.getProfCurrentUserInfo().then((value) {
        print(value.toString());
        followerInstance = NotificationModel(
          type: 'Prof Follower',
          From: UniversalVariables.myProfUid,
          fullname: value['BusinessName'],
          username: value['profUserName'],
          profileUrl: value['profUrl'],
          otherUserRelation: 'Following',
          To: widget.otherUserProfUid,
          timestamp: Timestamp.now(),
        );
        print(followerInstance.toString());
        DatabaseService.instance.sendFollowingConfirmation(followerInstance.toMap(followerInstance), widget.otherUserPvtUid);
      });
    }
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
                          image: NetworkImage(widget.otherUserProfile == null
                              ? UniversalVariables.defaultImageUrl
                              : widget.otherUserProfile),
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
                        Text(
                          widget.otherUserBusinessName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '@' + widget.otherUserName,
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
                            .getProfFollowersCountOfAUser(
                                widget.otherUserPvtUid,
                                widget.otherUserProfUid),
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
                                //print(snapshot.data);
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
                                return Text('Error:');
                              }
                          }
                        }),
                    Text(
                      'Followers',
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
                        future: DatabaseService.instance
                            .getProfFollowingCountOfAUser(
                                widget.otherUserPvtUid,
                                widget.otherUserProfUid),
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
                                return Text('Error');
                              }
                          }
                        }),
                    Text(
                      'Followings',
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
                  builder: (context, model, child) => Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 140.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: didFollow ? green : red,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  didFollow ? 'Following' : 'Follow',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                didFollow = !didFollow;
                              });
                              //TODO : Fix this!
                              if (didFollow) {
                                sendFollowerNotification();
                                if (widget.navigatedFromPrivateAc) {
                                  DatabaseService.instance.addMeAsAFollower(widget.otherUserPvtUid, widget.otherUserProfUid, true, UniversalVariables.myPvtUid);
                                  DatabaseService.instance.incrementMyPvtFollowing(widget.otherUserProfUid);
                                } else {
                                  DatabaseService.instance.addMeAsAFollower(widget.otherUserPvtUid, widget.otherUserProfUid, false, UniversalVariables.myProfUid);
                                  DatabaseService.instance.incrementMyProfFollowing(widget.otherUserProfUid);
                                }
                              }
                              else if (!didFollow) {
                                if (widget.navigatedFromPrivateAc) {
                                  DatabaseService.instance.removeMeAsAFollower(widget.otherUserPvtUid, widget.otherUserProfUid, UniversalVariables.myPvtUid);
                                  DatabaseService.instance.decrementMyPvtFollowing(widget.otherUserProfUid);
                                  DatabaseService.instance.removeFollowerNotification(widget.otherUserPvtUid, widget.otherUserProfUid, UniversalVariables.myPvtUid);
                                } else {
                                  DatabaseService.instance.removeMeAsAFollower(widget.otherUserPvtUid, widget.otherUserProfUid, UniversalVariables.myProfUid);
                                  DatabaseService.instance.decrementMyProfFollowing(widget.otherUserProfUid);
                                  DatabaseService.instance.removeFollowerNotification(widget.otherUserPvtUid, widget.otherUserProfUid, UniversalVariables.myProfUid);
                                }
                              }
                            },
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              widget.navigatedFromPrivateAc
                                  ? DatabaseService.instance
                                      .createOrGetConversation(
                                          widget.otherUserProfUid,
                                          'Private',
                                          'Professional', (String chatRoomId) {
                                      print(
                                          chatRoomId + 'In Future on Sucsess');
                                      return NavigationService.instance.pushTo(
                                          MaterialPageRoute(
                                              builder: (_) => ConversationPage(
                                                  navigatedFromPrivateAc: true,
                                                  chatRoomId: chatRoomId,
                                                  otherUserFullName: widget
                                                      .otherUserBusinessName,
                                                  otherUserUid:
                                                      widget.otherUserProfUid,
                                                  otherUserName:
                                                      widget.otherUserName,
                                                  otherUserProfileUrl: widget
                                                      .otherUserProfile)));
                                    })
                                  : DatabaseService.instance
                                      .createOrGetConversation(
                                          widget.otherUserProfUid,
                                          'Professional',
                                          'Professional', (String chatRoomId) {
                                      print(
                                          chatRoomId + 'In Future on Sucsess');
                                      return NavigationService.instance.pushTo(
                                          MaterialPageRoute(
                                              builder: (_) => ConversationPage(
                                                  navigatedFromPrivateAc: false,
                                                  chatRoomId: chatRoomId,
                                                  otherUserFullName: widget
                                                      .otherUserBusinessName,
                                                  otherUserUid:
                                                      widget.otherUserProfUid,
                                                  otherUserName:
                                                      widget.otherUserName,
                                                  otherUserProfileUrl: widget
                                                      .otherUserProfile)));
                                    });
                            }, //TODO: Open chatscreen
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
                      )),
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
                                          stream: DatabaseService.instance
                                              .getAllProfPostImageofOtherUser(
                                                  widget.otherUserPvtUid,
                                                  widget.otherUserProfUid),
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
                                              stream: DatabaseService.instance
                                                  .getAllProfPostMuseofOtherUser(
                                                      widget.otherUserPvtUid,
                                                      widget.otherUserProfUid),
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
              ) // end of col
            ],
          ),
        ),
      ),
    );
  }
}
