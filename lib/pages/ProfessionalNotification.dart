import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfessionalNotification extends StatefulWidget {
  @override
  _ProfessionalNotificationState createState() => _ProfessionalNotificationState();
}

class _ProfessionalNotificationState extends State<ProfessionalNotification> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: DatabaseService.instance.getProfNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of prof not');
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data == null || snapshot.data.documents.length == 0) {
              return Center(child: Container(child: Text('No professional notifications')));
            }

            var notifications = snapshot.data.documents;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                //print(notifications[i].data()['postUrl']==null);
                return Column(
                  children: [
                    notifications[i].data()['type'] !='Like' ? Dismissible(
                      key: Key(notifications[i].toString()),
                      onDismissed: (direction){
                        DatabaseService.instance.dismissFollowerNotification(notifications[i].data()['From']);
                      },
                      child: ListTile(
                          title: Text('${notifications[i].data()['fullname']} started following you'),
                          subtitle: Text(timeago.format(DateTime.tryParse(notifications[i].data()['timestamp'].toDate().toString())).toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(notifications[i].data()['profileUrl']),
                          ),
                          trailing: FlatButton(
                            color: red,
                            child: Text('Remove Follower', style: TextStyle(color: white),),
                            onPressed: (){
                              notifications[i].data()['type']=='Private Follower'? DatabaseService.instance.removePvtFollower(notifications[i].data()['From']) : DatabaseService.instance.removeProfFollower(notifications[i].data()['From']);
                              DatabaseService.instance.dismissFollowerNotification(notifications[i].data()['From']);
                            },
                          )
                      ),
                    ) : Dismissible(
                      key: Key(notifications[i].toString()),
                      onDismissed: (direction){
                        DatabaseService.instance.dismissLikeNotificationFromAFollower(notifications[i].data()['postId']);
                      },
                      child: ListTile(
                          title: Text('${notifications[i].data()['fullname']} has liked your post'),
                          subtitle: Text(timeago.format(DateTime.tryParse(notifications[i].data()['timestamp'].toDate().toString())).toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(notifications[i].data()['profileUrl']),
                          ),
                        /* trailing: (notifications[i].data()['postUrl']==null) ? ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                              maxWidth: 50,
                              maxHeight: 50,
                            ),
                            child: Image.network(notifications[i].data()['postUrl'], fit: BoxFit.cover),
                          ) : Text('')*/
                      ),
                    ),
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