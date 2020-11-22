import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegesection/models/Activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collegesection/services/activity_database.dart';

class ActivityDisplay extends StatefulWidget {
  final String uid;
  final ActivityDetails a;

  ActivityDisplay({this.uid, this.a});

  @override
  _ActivityDisplayState createState() => _ActivityDisplayState();
}

class _ActivityDisplayState extends State<ActivityDisplay> {
  bool requested = false;

  void initState() {
    checkRequested();
  }

  void checkRequested() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('ActivityRequests')
        .doc(widget.a.aid)
        .collection('requests')
        .doc(widget.uid)
        .get();
    if (doc.exists) {
      this.setState(() {
        requested = true;
      });
    } else {
      this.setState(() {
        requested = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.a.activityTitle,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(widget.a.description),
              SizedBox(
                height: 20.0,
              ),
              widget.a.activityType != 'Skill'
                  ? Text('Required: ' +
                      widget.a.noOfPlayers.toString() +
                      'Players')
                  : Container(),
              RaisedButton(
                onPressed: () async {
                  if (!requested) {
                    await ActivityDatabaseService(uid: widget.uid)
                        .addRequest(widget.a.aid);
                    this.setState(() {
                      requested = true;
                    });
                  }
                },
                color: requested ? Colors.white : Colors.greenAccent,
                child: requested ? Text('Send request') : Text('Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
