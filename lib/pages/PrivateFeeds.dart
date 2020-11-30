import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/model/connection.dart';
import 'package:flutter/material.dart';
import 'package:yibe_final_ui/pages/Share.dart';
import 'package:yibe_final_ui/pages/comments.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yibe_final_ui/pages/Message.dart';
import 'package:yibe_final_ui/pages/Notification.dart';

class PrivateFeeds extends StatefulWidget {

  @override
  _PrivateFeedsState createState() => _PrivateFeedsState();
}

class _PrivateFeedsState extends State<PrivateFeeds> {
  static NotificationModel likeInstance = NotificationModel();
  Stream allCloseFriendFeeds;
  Stream allFriendFeeds;
  Stream allAcquaintanceFeeds;
  Stream allPvtFollowingsFeeds;
  Stream allFeeds;
  int page = 0;

  @override
  void initState(){
    super.initState();
    Stream<QuerySnapshot> closeFriendFeeds = DatabaseService.instance.getAllCloseFriendsFeeds();
    Stream<QuerySnapshot> friendsFeeds = DatabaseService.instance.getAllFriendsFeeds();
    Stream<QuerySnapshot> acquaintanceFeeds = DatabaseService.instance.getAllAcquaintanceFeeds();
    Stream<QuerySnapshot> followingsFeeds = DatabaseService.instance.getAllPvtFollowingsFeeds();
    Stream<QuerySnapshot> allPvtFeeds = DatabaseService.instance.getAllMyPvtFeeds();
    setState(() {
      allCloseFriendFeeds= closeFriendFeeds;
      allFriendFeeds = friendsFeeds;
      allAcquaintanceFeeds = acquaintanceFeeds;
      allPvtFollowingsFeeds = followingsFeeds;
      allFeeds = allPvtFeeds;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(46.0),
          child: AppBar(
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return NotificationPage();
                            }));
                      },
                      child: SvgPicture.asset(
                        "assets/images/notifications_none-24px 1.svg",
                        width: 28,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onLongPress: () {
                        //widget.hiberPopUp(true);
                      },
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Messages();
                            }));
                      },
                      child: Icon(Icons.send, size: 28, color: Colors.black),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: ListView(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'All',
                      style:
                      TextStyle(color: page==0 ? primaryColor : grey, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Close Friends',
                      style:
                      TextStyle(color: page==1 ? primaryColor : grey, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 2;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Friends',
                      style: TextStyle(
                          color: page==2 ? primaryColor : grey, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 3;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Acquaintance',
                      style: TextStyle(
                          color: page==3 ? primaryColor : grey, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 4;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Followings',
                          style: TextStyle(
                              color: page==4 ? primaryColor : grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5.0,
            color: Colors.black,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: page==0 ? listofallFeeds() : page==1 ? listofallCloseFriendFeeds() : page==2 ? listofallFriendsFeeds() : page==3 ? listofallAcquaintanceFeeds() : page==4 ? listofallPvtFollowingsFeeds() :  Container()
          ),
        ]));
  }

  Widget listofallCloseFriendFeeds(){
    return StreamBuilder(
        stream: allCloseFriendFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of CF feeds');
            return Center(child: Container(child: Text('loading...')));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No close friend feeds')));
          }
          var posts = snapshot.data.documents;
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      postTile(posts[i]),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            )
          ]);
        });
  }

  Widget listofallFriendsFeeds(){
    return StreamBuilder(
        stream: allFriendFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of F feeds');
            return Center(child: Container(child: Text('loading...')));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No friend feeds')));
          }
          var posts = snapshot.data.documents;
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      postTile(posts[i]),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            )
          ]);
        });
  }


  Widget listofallAcquaintanceFeeds(){
    return StreamBuilder(
        stream: allAcquaintanceFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of AQ feed');
            return Center(child: Container(child: Text('loading...')));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No acquaintance feeds')));
          }
          var posts = snapshot.data.documents;
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      postTile(posts[i]),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            )
          ]);
        });
  }

  Widget listofallPvtFollowingsFeeds(){
    return StreamBuilder(
        stream: allPvtFollowingsFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of following feeds');
            return Center(child: Container(child: Text('loading...')));
          }
          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No feeds')));
          }
          var posts = snapshot.data.documents;
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      postTile(posts[i]),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            )
          ]);
        });
  }


  Widget listofallFeeds(){
    return StreamBuilder(
        stream: allFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of all feeds');
            return Center(child: Container(child: Text('Loading....')));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No feeds')));
          }
          var posts = snapshot.data.documents;
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      postTile(posts[i]),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            )
          ]);
        });
  }


  Widget postTile(QueryDocumentSnapshot post) {

    void addMyLikeToAPost(String postFrom, String postFor, String postId, String postUrl, String image) async {
      print('post url of liked feed');
      print(postUrl);
      await DatabaseService.instance.getPvtProfileUrlofAUser(UniversalVariables.myPvtUid).then((value) {
        likeInstance = NotificationModel(
          type: 'Like',
          From: UniversalVariables.myPvtUid,
          fullname: UniversalVariables.myPvtFullName,
          username: UniversalVariables.myPvtUsername,
          timestamp: Timestamp.now(),
          profileUrl: value!=null ? value : UniversalVariables.defaultImageUrl,
          To: postFrom,
          otherUserRelation: postFor != 'Follower' ? 'Connection' : 'Following',
        );
      });
      print(likeInstance.toMap(likeInstance));
      await DatabaseService.instance.addLikeToAPostInMyPvtFeed(likeInstance.toMap(likeInstance), postId, postFrom, postFor, postUrl);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(post.data()['image']),
        ),
        title: Text(post.data()['name'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(timeago
        .format(DateTime.tryParse(
       post.data()['timestamp'].toDate().toString()))
        .toString(),
          style: TextStyle(
            color: Color(0xFfA7A7A7),
            fontSize: 14.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Share();
              }));
            },
            child: Icon(Icons.more_vert)),
      ),
     post.data()["type"] == "image"
          ?  Column(
            children: [
              Container(
        width: MediaQuery.of(context).size.width,
        height: 300.0,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(post.data()["postUrl"]),
              fit: BoxFit.cover,
            ),
        ),
      ),
    Padding(
    padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
    child: Container(child: Text(post.data()["caption"]))),])
          : Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
          child: Container(child: Text(post.data()["postText"]))),

     /* GestureDetector(
        onTap: (){
          print("hi");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
                child: Container(child: Text(post.data()["caption"]))),

           Container(
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(post.data()["postUrl"]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ],
        ),
      ),*/
      SizedBox(height: MediaQuery.of(context).size.height * 0.015),
      Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SizedBox(width: 15.0),
            post.data().containsKey('isLiked') && post.data()['isLiked']==true ? IconButton(icon: Icon(Icons.favorite),
                onPressed: () {
                  DatabaseService.instance.removeLikeFromAPostInMyPvtFeed(post.data()['postId'], post.data()['postFrom']);
                }) : IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: (){
                addMyLikeToAPost(post.data()['postFrom'], post.data()['postFor'], post.data()['postId'], post.data()['postUrl'], post.data()['image']);
              },
            ),
            SizedBox(width: 5.0),
            Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  //widget.user["like"] + " Yibed",
                  '34 Yibed',
                  style: TextStyle(fontSize: 12),
                )),
            Spacer(),
            GestureDetector(
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Comment(
                      //isPrivate: true,
                      profileImage: post.data()['image'],
                      likeCount: '34',
                      name: post.data()['name'],
                      time: timeago.format(DateTime.tryParse(post.data()['timestamp'].toDate().toString())).toString(),
                      type: post.data()['type'],
                      postImage: post.data()['postUrl'],
                      postText: post.data()['postText'],
                      msg:post.data()['caption'],
                    );
                  }));
                },
                child: SvgPicture.asset('assets/images/message_icon_homePage.svg')),
            SizedBox(width: 15.0),
            SizedBox(width: 15.0),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Share();
                  }));
                },
                child: SvgPicture.asset('assets/images/share_logo.svg')),
            SizedBox(width: 15.0),
          ],
        ),
      ),
      //SizedBox(height: 15.0),
     /* widget.user["type"] == "embedded"
          ? Container()
          : Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
          child: Container(child: Text(widget.user["msg"]))),
      SizedBox(height: 15.0),*/
      Divider(
        thickness: 1.0,
      ),
    ]);

    //TODO : Update profile pic of the user if changed after posting
   return Container(
      height: 500,
      width: 500,
      child: Card(
        child: Column(
          children: [
            ListTile(
                title: Text(post.data()['name']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(post.data()['image']),
                )
            ),
            Container(
              height: 300.0,
              width: 320.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post.data()['postUrl']),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Container(
                height: 80.0,
                width: 300.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    post.data().containsKey('isLiked') && post.data()['isLiked']==true ? IconButton(icon: Icon(Icons.favorite),
                        onPressed: () {
                          DatabaseService.instance.removeLikeFromAPostInMyPvtFeed(post.data()['postId'], post.data()['postFrom']);
                        }) : IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: (){
                        addMyLikeToAPost(post.data()['postFrom'], post.data()['postFor'], post.data()['postId'], post.data()['postUrl'], post.data()['image']);
                      },
                    ),
                    Row(
                      children: [
                        Text(post.data()['name'], style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5.0,),
                        Text(post.data()['caption']),
                      ],
                    ),
                    Text(timeago.format(DateTime.tryParse(post.data()['timestamp'].toDate().toString())).toString())
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
