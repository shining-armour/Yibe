import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class Comment extends StatefulWidget {

  final String profileImage;
  final String name;
  final String time;
  final String likeCount;
  final String type;
  final String postText;
  final String postImage;
  final String msg;

  const Comment({
    this.profileImage,
    this.name,
    this.time,
    this.likeCount,
    this.type,
    this.postText,
    this.postImage,
    this.msg,
  });

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController _commentController = TextEditingController();
  bool isliked=false;
  bool commentSent = false;
  Map profUserMap;
  String privateUrl;

  @override
  void initState() {
    super.initState();
    DatabaseService.instance.getPvtCurrentUserInfo(UniversalVariables.myPvtUid).then((value) => {
      value['privateUrl'] != null ? setState(() {
        privateUrl = value['privateUrl'];
      }) : setState(() {
        privateUrl = UniversalVariables.defaultImageUrl;
      })
    });
    DatabaseService.instance.getProfCurrentUserInfo().then((value) => setState(() {
      profUserMap = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        actions: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: ()=> NavigationService.instance.goBack(),
                  child: SvgPicture.asset(
                    'assets/images/back_btn.svg',
                    // width: 31.0,
                    height: 16.0,
                  ),
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
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
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
      body: Consumer<AcType>(
        builder: (context,model,child) => Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.profileImage),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: Text(
                      widget.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    child: Text(
                      widget.time,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                widget.type == "text"
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            widget.postText,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth,
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.postImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16.0, top: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.msg,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: screenWidth,
                  child: Row(
                    children: [
                      SizedBox(width: 15.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isliked) {
                              isliked = false;
                            } else {
                              isliked = true;
                            }
                          });
                        },
                        child: isliked
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                                size: 30.0,
                              ),
                      ),
                      SizedBox(width: 5.0),
                      Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.likeCount + " Yibed",
                            style: TextStyle(fontSize: 12),
                          )),
                      Spacer(),
                      SvgPicture.asset('assets/images/message_icon_homePage.svg'),
                      SizedBox(width: 15.0),
                      SizedBox(width: 15.0),
                      SvgPicture.asset('assets/images/share_logo.svg'),
                      SizedBox(width: 15.0),
                    ],
                  ),
                ),

                Divider(
                  thickness: 1.0,
                ),
                Container(padding:EdgeInsets.only(left:15),
                  width: double.infinity,
                  child: Text(
                    "Comments",
                    style: TextStyle(color: Colors.black, fontSize:16.0,fontWeight:FontWeight.w500),
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      var user = _commentList[index];
                      return commentSent ? ListTile(
                        leading: CircleAvatar(
                          backgroundImage: model.isPrivate ?  NetworkImage(privateUrl): NetworkImage(profUserMap['profUrl']) ,
                        ),
                        title: Text(model.isPrivate ? UniversalVariables.myPvtFullName : profUserMap['BusinessName']),
                        subtitle: Text(_commentController.text)
                      ): Container();
                    },
                  ),
                ),
              ],
            ),
           Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                           Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: CircleAvatar(
                        backgroundImage: model.isPrivate ?  NetworkImage(privateUrl): NetworkImage(profUserMap['profUrl']) ,
                      ),
                    ),
                  ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
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
                              //  border: BoxBorder(),
                              border: Border.all(color: Color(0xff008294)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                           child: TextField(
                                          controller: _commentController,
                                          // style: simpleTextStyle(),
                                          decoration: InputDecoration(
                                              hintText: model.isPrivate ? "Post as " + UniversalVariables.myPvtFullName : "Post as "+ profUserMap['BusinessName'],
                                              hintStyle: TextStyle(
                                                color: Color(0xFFA7A7A7),
                                                fontSize: 16,
                                              ),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      GestureDetector(
                                          child: SvgPicture.asset('assets/images/message_icon_homePage.svg', color: Color(0xff008294),),
                                      onTap: (){
                                            setState(() {
                                              commentSent = true;
                                            });
                                      },),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map> _commentList = [
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
    {
      "profileImage": "assets/images/Rajani Suryavanshi.png",
      "message": "hello",
      "name": "louis"
    },
  ];
}
