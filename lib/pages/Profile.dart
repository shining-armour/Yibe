import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:yibe_final_ui/model/post.dart';
import 'package:yibe_final_ui/pages/MyPvtFollowing.dart';
import 'package:yibe_final_ui/pages/MyConnections.dart';
import 'package:yibe_final_ui/pages/MyFollowers.dart';
import 'package:yibe_final_ui/pages/MyProfFollowings.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'Gallery.dart';
import 'package:timeago/timeago.dart' as timeago;

double screenWidth;
String currentAcType = 'Private';

class Profile extends StatefulWidget {
  bool navigatedFromSetUpProfAc;
  Profile({this.navigatedFromSetUpProfAc});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color green = Color(0xFF0CB5BB);
  Color blue = Color(0xFF424283);
  //bool _isPrivate = true;
  bool isPost = true;
  bool isMuse = false;
  bool isTimeline = false;
  bool ownPhoto = true;
  bool tagPhoto = false;
  bool museList = true;
  bool museSync = false;
  bool haveProfAc = false;
  Map profUserMap;
  String privateUrl;
  String pvtBio;
  int connectionsCount = 0;
  int pvtfollowingsCount = 0;
  int followersCount = 0;
  int proffollowingsCount = 0;

  @override
  void initState() {
    super.initState();
    CountofConnectionsandFollowings();
    DatabaseService.instance.getProfAcStatus().then((value) => setState(() {
      haveProfAc = value;
    }));
    DatabaseService.instance.getProfCurrentUserInfo().then((value) => setState(() {
      profUserMap = value;
    }));
    CountofProfFollowersAndFollowing();
    DatabaseService.instance.getPvtCurrentUserInfo(UniversalVariables.myPvtUid).then((value) => {
      value['privateUrl'] != null && value['pvtBio']!=null ? setState(() {
        privateUrl = value['privateUrl'];
        pvtBio = value['pvtBio'];
      }) : setState(() {
        privateUrl = UniversalVariables.defaultImageUrl;
        pvtBio = 'Bio is Empty';
      })
    });
    if(widget.navigatedFromSetUpProfAc==null){
      setState(() {
        widget.navigatedFromSetUpProfAc = false;
      });
    }

    print('............profile condition..........');
    print(widget.navigatedFromSetUpProfAc);
    print(haveProfAc);
  }

  void CountofProfFollowersAndFollowing(){
    DatabaseService.instance.getProfFollowersCountOfAUser(UniversalVariables.myPvtUid,UniversalVariables.myProfUid).then((value) => setState(() {
      followersCount = value;
      print(followersCount.toString() + ' follower in view my prof');
    }));
    DatabaseService.instance.getProfFollowingCountOfAUser(UniversalVariables.myPvtUid, UniversalVariables.myProfUid).then((value) => setState(() {
      proffollowingsCount = value;
      print(proffollowingsCount.toString() + ' following in view my prof');
    }));
  }

  void CountofConnectionsandFollowings() {
    DatabaseService.instance
        .getConnectionCountOfAUser(UniversalVariables.myPvtUid)
        .then((value) => setState(() {
      connectionsCount = value;
      print(connectionsCount.toString() + ' connections in my profile');
    }));
    DatabaseService.instance
        .getPvtFollowingCountOfAUser(UniversalVariables.myPvtUid)
        .then((value) => setState(() {
      pvtfollowingsCount = value;
      print(pvtfollowingsCount.toString() + ' followings in my profile');
    }));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Gallery();
                  }));
                },
                child: SvgPicture.asset('assets/images/add_btn.svg',
                    width: 24.0, height: 24.0, color: Color(0xFF0CB5BB)),
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  'assets/images/setting.svg',
                  width: 24.0,
                  height: 24.0,
                ),
                onTap: () => NavigationService.instance.pushNamedTo('settings'),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Consumer<AcType>(
            builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (haveProfAc || widget.navigatedFromSetUpProfAc) ?
                Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: model.isPrivate ? green : blue,
                              width: 2,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(100))),
                        width: screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: GestureDetector(
                                    onTap: () => model.changeAcType(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: model.isPrivate
                                              ? green
                                              : Colors.white,
                                          border: Border.all(
                                              color: model.isPrivate
                                                  ? green
                                                  : Colors.white,
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "Private",
                                        style: TextStyle(
                                            color: model.isPrivate
                                                ? Colors.white
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ))),
                            Expanded(
                                child: GestureDetector(
                                  onTap: () {model.changeAcType(); print(model.isPrivate);},
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color:
                                        model.isPrivate ? Colors.white : blue,
                                        border: Border.all(
                                            color: model.isPrivate
                                                ? Colors.white
                                                : blue,
                                            width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Text(
                                      "Professional",
                                      style: TextStyle(
                                          color: model.isPrivate
                                              ? Colors.grey
                                              : Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                )),
                          ],
                        ))
                        : Container(),
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
                            image: model.isPrivate ? NetworkImage(privateUrl) : NetworkImage(profUserMap['profUrl']) ,
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
                              model.isPrivate
                                  ? UniversalVariables.myPvtFullName
                                  : profUserMap['BusinessName'] != null
                                  ? profUserMap['BusinessName']
                                  : 'No Business name',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              model.isPrivate
                                  ? '@' + UniversalVariables.myPvtUsername
                                  : profUserMap['profUserName'] != null
                                  ? '@' + profUserMap['profUserName']
                                  : 'No username',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              model.isPrivate ? pvtBio : profUserMap['BusinessBio'],
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
                model.isPrivate ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Connections();
                                    }));
                              },
                              child: Text(
                                connectionsCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MyPrivateFollowings();
                                }));
                          },
                          child: Column(
                            children: [
                              Text(
                                pvtfollowingsCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                        ),
                      ])
                      : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MyProfFollowers();
                                }));
                          },
                          child: Column(
                            children: [
                              Text(
                                followersCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                        ),
                        SizedBox(width: 70),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return MyProfFollowings();
                                }));
                          },
                          child: Column(
                            children: [
                              Text(
                                proffollowingsCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                        ),
                      ]),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        GestureDetector(
                          onTap: (){
                            model.isPrivate ? NavigationService.instance.pushNamedTo('editPrivate') : NavigationService.instance.pushNamedTo('editProfessional');
                          },
                          child: Container(
                            width: 300,
                            height: 30.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: green,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    /*  Spacer(),
                      Container(
                        width: 140.0,
                        height: 28.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: green,
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
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                SizedBox(
                    height: 12.0), // now onwards diff for private and professional
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
                                stream: model.isPrivate ? DatabaseService.instance.getAllMyPvtPostImage() : DatabaseService.instance.getAllMyProfPostImage(),
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
                                  stream: model.isPrivate ? DatabaseService.instance.getAllMyPvtPostMuse() : DatabaseService.instance.getAllMyProfPostMuse(),
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
                                                        image: model.isPrivate ? NetworkImage(privateUrl) : NetworkImage(profUserMap['profUrl']),
                                                        fit: BoxFit
                                                            .fill,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    model.isPrivate ? '@'+UniversalVariables.myPvtUsername :'@'+profUserMap['profUserName'],
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
                )// end of col
              ],
            )
          )
        ),
      ),
    );
  }
}
