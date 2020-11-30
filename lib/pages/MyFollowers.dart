import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';

class MyProfFollowers extends StatefulWidget {

  @override
  _MyProfFollowersState createState() => _MyProfFollowersState();
}

class _MyProfFollowersState extends State<MyProfFollowers> {
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
                      ListTile(
                          title: Text(users[i].data()['name']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                users[i].data()['url']),
                          ))
                    ],
                  );},
              );
            }
          ),
    );
  }
}