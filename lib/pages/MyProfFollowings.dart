import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/pages/viewOtherUserProfProfile.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';

class MyProfFollowings extends StatefulWidget {

  @override
  _MyProfFollowingsState createState() => _MyProfFollowingsState();
}

class _MyProfFollowingsState extends State<MyProfFollowings> {
  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
          stream: DatabaseService.instance.getAllMyProfFollowings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of prof followings');
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null || snapshot.data.documents.length == 0) {
              return Center(
                  child: Container(child: Text('No followings yet')));
            }

            var users = snapshot.data.documents;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap:(){
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
                        },
                        child: ListTile(
                            title: Text(users[i].data()['name']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  users[i].data()['url']),
                            )),
                      ),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );},
              );
            }),
    );
  }
}