import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/model/connection.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yibe_final_ui/pages/Share.dart';
import 'package:yibe_final_ui/pages/comments.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yibe_final_ui/pages/Message.dart';
import 'package:yibe_final_ui/pages/Notification.dart';
import 'package:yibe_final_ui/widget/custom_dialog_box.dart';

class ProfFeeds extends StatefulWidget {

  @override
  _ProfFeedsState createState() => _ProfFeedsState();
}

class _ProfFeedsState extends State<ProfFeeds> {
  static NotificationModel likeInstance = NotificationModel();
  Stream ProfFollowingStream;

  @override
  void initState(){
    super.initState();
    Stream<QuerySnapshot> pfs = DatabaseService.instance.getAllMyProfFeeds();
    setState(() {
      ProfFollowingStream = pfs;
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                            title: "Hibernation Mode",
                            description:  "Only selected messages will be accessable. Other features of the application cannot be used during hibernation",
                            primaryButtonText: "Activate",
                            primaryButtonRoute: "hybernation",
                            secondaryButtonText: "Cancel",
                            secondaryButtonRoute: "pageHandler",
                          ),
                        );
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
            height: MediaQuery.of(context).size.height * 0.8,
            child: listofProfFeeds(),
          ),
        ]));
  }

  Widget listofProfFeeds(){
    return StreamBuilder(
        stream: ProfFollowingStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of F feeds');
            return Center(child: Container(child: CircularProgressIndicator()));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No feeds are posted by your professional followings')));
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

    void addMyLikeToAPost(String postFrom, String postFor, String postId, String postUrl) async {
      await DatabaseService.instance.getProfCurrentUserInfo().then((value) {
        likeInstance = NotificationModel(
          type: 'Like',
          From: UniversalVariables.myProfUid,
          fullname: value['BusinessName'],
          username: value['profUserName'],
          profileUrl: value['profUrl'],
          To: postFrom,
          otherUserRelation: 'Following',
          timestamp: Timestamp.now(),
        );
        DatabaseService.instance.addLikeToAPostInMyProfFeed(likeInstance.toMap(likeInstance), postId, postFrom, postFor, postUrl);
      });
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
            post.data().containsKey('isLiked') && post.data()['isLiked']==true ? IconButton(icon: Icon(Icons.favorite, color: Colors.red,),
                onPressed: () {
                  DatabaseService.instance.removeLikeFromAPostInMyProfFeed(post.data()['postId'], post.data()['postFrom']);
                }) : IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: (){
                addMyLikeToAPost(post.data()['postFrom'], post.data()['postFor'], post.data()['postId'], post.data()['postUrl']);
              },
            ),
            SizedBox(width: 5.0),
            Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  post.data().containsKey('isLiked') && post.data()['isLiked']==true ? '1 Yibed' : '0 Yibed',
                  style: TextStyle(fontSize: 12),
                )),
            Spacer(),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Comment(
                      //isPrivate: true,
                      profileImage: post.data()['image'],
                      likeCount: post.data().containsKey('isLiked') && post.data()['isLiked']==true ? '1' : '0',
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

  }
}
