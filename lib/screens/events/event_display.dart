import 'package:collegesection/models/event.dart';
import 'package:collegesection/services/eventdatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDisplay extends StatelessWidget {
  final String eid, uid;

  EventDisplay({this.eid, this.uid});
  EventDetails details;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<EventDetails>(
        stream: EventDatabaseService(uid: uid).getEventDetails(eid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            details = snapshot.data;
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.25,
                        child: Image.network(
                          details.posterUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        details.eventName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.0),
                      ),
                      Row(
                        children: [
                          Icon(Icons.bookmark),
                          Text(
                            details.eventType,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today),
                          Text(
                            details.dateOfEvent + ' ' + details.timeOfEvent,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'About The Event',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(details.description),
                      SizedBox(height: 20.0),
                      Text(
                        'Eligibility',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(details.eligibility),
                      SizedBox(height: 20.0),
                      Text(
                        'Other Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(details.otherDetails),
                      SizedBox(height: 20.0),
                      Text(
                        'Venue',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(details.address),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                child: RaisedButton(
                  onPressed: () {},
                  child: Text('Register'),
                  color: Colors.blue,
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
            );
          }
        });
  }
}
