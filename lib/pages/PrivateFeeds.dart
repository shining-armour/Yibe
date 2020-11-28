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
import 'package:yibe_final_ui/widget/custom_dialog_box.dart';

class PrivateFeeds extends StatefulWidget {
  String feedOf;
  Stream feedStream;
  PrivateFeeds({this.feedStream, this.feedOf});

  @override
  _PrivateFeedsState createState() => _PrivateFeedsState();
}

class _PrivateFeedsState extends State<PrivateFeeds> {
  static NotificationModel likeInstance = NotificationModel();
  Stream allPvtFeeds;

  @override
  void initState(){
    super.initState();
    print(widget.feedOf);
    print(UniversalVariables.myPvtUid);
    Stream<QuerySnapshot> pfs = DatabaseService.instance.getAllMyPvtFeeds();
    setState(() {
      allPvtFeeds = pfs;
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
                            description:
                            "Only selected messages will be accessable. Other features of the application cannot be used during hibernation",
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
              child: widget.feedOf!=null ? listofSelectedFeeds() : listofAllPvtFeeds(),
          ),
        ]));
  }


  Widget listofSelectedFeeds(){
    return StreamBuilder(
        stream: widget.feedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of Pvt feeds');
            return Center(child: Container(child: CircularProgressIndicator()));
          }

          if (snapshot.data == null || snapshot.data.documents.length == 0) {
            return Center(child: Container(child: Text('No feeds are posted by your ' + widget.feedOf)));
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

  Widget listofAllPvtFeeds(){
    return StreamBuilder(
        stream: allPvtFeeds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('in waiting of Pvt feeds');
            return Center(child: Container(child: CircularProgressIndicator()));
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
      //print('post url of liked feed');
      //print(postUrl);
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
            post.data().containsKey('isLiked') && post.data()['isLiked']==true ? IconButton(icon: Icon(Icons.favorite, color: Colors.red,),
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
