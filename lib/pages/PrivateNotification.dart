import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yibe_final_ui/model/connection.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/messaging_service.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;


class PrivateNotification extends StatefulWidget {
  @override
  _PrivateNotificationState createState() => _PrivateNotificationState();
}

class _PrivateNotificationState extends State<PrivateNotification> {
  static ConnectionModel senderConnectionInstance = ConnectionModel();
  static ConnectionModel receiverConnectionInstance = ConnectionModel();
  static NotificationModel connectionConfirmInstance = NotificationModel();

  @override
  void initState(){
    MessagingService.instance.sendNotification();
    super.initState();
  }
  Future addUserInMyConnectionAs(context, DocumentSnapshot notification){
    return showDialog(context: context, builder:(context)
    {
      return SimpleDialog(
          title: Text('Add To', textAlign: TextAlign.center,),
          children: <Widget>[
            SimpleDialogOption(
                child: Text('Friend'),
                onPressed: () {
                  addToMyConnection('F', notification);
                }
            ),
            SimpleDialogOption(
                child: Text('Close Friend'),
                onPressed: () {
                  addToMyConnection('CF', notification);
                }),
            SimpleDialogOption(
                child: Text('Acquaintance'),
                onPressed: () {
                  addToMyConnection('AQ', notification);
                }),
            SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => NavigationService.instance.goBack()
            ),
          ]);
    });
  }


  void addToMyConnection(type, DocumentSnapshot notification)  {
    NavigationService.instance.goBack();
    DatabaseService.instance.getPvtProfileUrlofAUser(UniversalVariables.myPvtUid).then((value) {
    senderConnectionInstance = ConnectionModel(
      uid: notification.data()['To'],
      fullname: UniversalVariables.myPvtFullName,
      profileUrl: value!=null ? value : UniversalVariables.defaultImageUrl,
      myRelation: notification.data()['otherUserRelation'],
      otherUserRelation: type,
      username: UniversalVariables.myPvtUsername,
    );
    receiverConnectionInstance = ConnectionModel(
      uid: notification.data()['From'],
      username: notification.data()['username'],
      fullname: notification.data()['fullname'],
      profileUrl: notification.data()['profileUrl'],
      myRelation: type,
      otherUserRelation: notification.data()['otherUserRelation'],
    );
    DatabaseService.instance.acceptConnectionRequest(notification.data()['From'], senderConnectionInstance.toMap(senderConnectionInstance), receiverConnectionInstance.toMap(receiverConnectionInstance)).then((value) => sendConnectionConfirmation(notification, type));});

  }

  Future<void> sendConnectionConfirmation(DocumentSnapshot notification, type) async {
    connectionConfirmInstance = NotificationModel(
      type: 'Connection Accepted',
      From: notification.data()['To'],
      To: notification.data()['From'],
      fullname: UniversalVariables.myPvtFullName,
      username: UniversalVariables.myPvtUsername,
      profileUrl: UniversalVariables.defaultImageUrl,
      otherUserRelation: type,
      timestamp: Timestamp.now(),
    );
    await DatabaseService.instance.sendConnectionConfirmation(
        connectionConfirmInstance.toMap(connectionConfirmInstance));
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
          stream: DatabaseService.instance.getPvtNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('in waiting of pvt not');
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.data == null || snapshot.data.documents.length == 0) {
              return Center(child: Container(child: Text('No private notifications')));
            }

            var notifications = snapshot.data.documents;
            print(notifications);
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                print(notifications[i].data());
                return Column(
                  children: [
                    notifications[i].data()['type']=='Connection Request' ? ListTile(
                      title: Text('${notifications[i].data()['fullname']} has sent you a connection request!'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            notifications[i].data()['profileUrl']),
                      ),
                      subtitle: Text(timeago.format(DateTime.tryParse(notifications[i].data()['timestamp'].toDate().toString())).toString()),
                      trailing: Wrap(
                        children: [
                          InkWell(child: CircleAvatar(child: Icon(Icons.cancel), backgroundColor: red), onTap: () => DatabaseService.instance.rejectConnectionRequest(notifications[i].data()['From'])),
                          SizedBox(width: 5.0),
                          InkWell(child: CircleAvatar(child: Icon(Icons.check_circle), backgroundColor: green), onTap: (){
                            addUserInMyConnectionAs(context, notifications[i]);
                          }),],
                      ),
                    ) : notifications[i].data()['type']=='Like' ? Dismissible(
                        key: Key(notifications[i].toString()),
                        onDismissed: (direction){
                          DatabaseService.instance.dismissLikeNotificationFromAConnection(notifications[i].data()['postId']);
                        },
                        child: ListTile(
                            title: Text('${notifications[i].data()['fullname']} has liked your post'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(notifications[i].data()['profileUrl']),
                            ),
                            subtitle: notifications[i].data()['timestamp']!=null ? Text(timeago.format(DateTime.tryParse(notifications[i].data()['timestamp'].toDate().toString())).toString()) :Text('timestamp null'),
                            trailing: notifications[i].data()['postUrl']!=null ?  ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                                maxWidth: 50,
                                maxHeight: 50,
                              ),
                              child: Image.network(notifications[i].data()['postUrl'], fit: BoxFit.cover),
                            ): Container())) :
                    notifications[i].data()['type']=='Connection Accepted' ? Dismissible(
                        key: Key(notifications[i].toString()),
                        onDismissed: (direction){
                          DatabaseService.instance.dismissConnectionConfirmation(notifications[i].data()['From']);
                        },
                        child: ListTile(
                          subtitle:  Text(timeago.format(DateTime.tryParse(notifications[i].data()['timestamp'].toDate().toString())).toString()),
                          title: Text('${notifications[i].data()['fullname']} is now a connection'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(notifications[i].data()['profileUrl']),
                          ),
                        )) : Center(child: Container(child: Text('No private notifications'))),
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