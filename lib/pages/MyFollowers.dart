import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/pages/viewOtherUserProfProfile.dart';
import 'package:yibe_final_ui/pages/viewOtherUserPvtProfile.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/services/snack_bar_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class MyProfFollowers extends StatefulWidget {

  @override
  _MyProfFollowersState createState() => _MyProfFollowersState();
}

class _MyProfFollowersState extends State<MyProfFollowers> {
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
      ),
      body: StreamBuilder(
          stream: DatabaseService.instance.getAllMyProfFollowers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of prof followers');
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data == null || snapshot.data.documents.length == 0) {
              return Center(child: Container(child: Text('No followers yet')));
            }

            var users = snapshot.data.documents;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Divider(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(users[i].data()['uid'].toString().contains('-')){
                          DatabaseService.instance.getAnyProfUserInfo(users[i].data()['uid']).then((value) => {
                             NavigationService.instance.pushTo( MaterialPageRoute(builder: (context) => ViewOtherUserProfProfile(
                               navigatedFromPrivateAc: false,
                               otherUserPvtUid: value['pvtId'],
                               otherUserProfUid: value['profId'],
                               otherUserBusinessName: value['BusinessName'],
                               otherUserProfile: value['profUrl'],
                               otherUserBio: value['BusinessBio'] ?? 'Bio is Empty',
                               otherUserName: value['profUserName'],
                             )))
                          });
                          } else{
                            SnackBarService.instance.showSnackBar(_scaffoldKey, 'You cannot view private user profile');
                          }
                        },
                        child: ListTile(
                            title: Text(users[i].data()['name']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  users[i].data()['url']),
                            )),
                      )
                    ],
                  );},
              );
            }
          ),
    );
  }
}