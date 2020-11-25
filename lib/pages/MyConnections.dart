import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';

class Connections extends StatefulWidget {

  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
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
          stream: DatabaseService.instance.getAllMyConnections(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of incircle');
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data == null || snapshot.data.documents.length == 0) {
              return Center(child: Container(child: Text('No connections yet')));
            }
            var users = snapshot.data.documents;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(users[i].data()['fullname']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              users[i].data()['profileUrl']),   //TODO: Change with updated profile pic
                        ),
                        trailing: Text(users[i].data()['myRelation']),
                      ),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );},
              );
            }
          ),
    );
  }
}