import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';

class MyPrivateFollowings extends StatefulWidget {
  @override
  _MyPrivateFollowingsState createState() => _MyPrivateFollowingsState();
}

class _MyPrivateFollowingsState extends State<MyPrivateFollowings> {
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
          stream: DatabaseService.instance.getAllMyPvtFollowings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of incircle');
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
                    ListTile(
                        title: Text(users[i].data()['name']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(users[i].data()['url']),
                        )),
                    Divider(
                      height: 10.0,
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
