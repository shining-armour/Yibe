import 'package:collegesection/models/event.dart';
import 'package:collegesection/screens/events/event_display.dart';
import 'package:collegesection/services/eventdatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collegesection/screens/events/add_event.dart';
import 'package:collegesection/screens/mapscreens/events_map.dart';

class Events extends StatefulWidget {
  final String uid;

  Events(this.uid);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> events;
  EventDetails details;
  int sortValue = 2;
  int page = 0;

  void _showSortingOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          child: Column(
            children: [
              Text('Filter & Sort'),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: sortValue,
                    onChanged: (value) {
                      setState(() {
                        sortValue = value;
                      });
                    },
                  ),
                  Text('Latest to Oldest'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: sortValue,
                    onChanged: (value) {
                      setState(() {
                        sortValue = value;
                      });
                    },
                  ),
                  Text('Show only nearest'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: sortValue,
                    onChanged: (value) {
                      setState(() {
                        sortValue = value;
                      });
                    },
                  ),
                  Text('Random'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: size.height * 0.07,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    _showSortingOptions(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.filter_list,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'All',
                      style:
                          TextStyle(color: Colors.pinkAccent, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'College Fests',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 2;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Music Fests',
                      style:
                          TextStyle(color: Colors.amberAccent, fontSize: 20.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      page = 3;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Parties',
                      style: TextStyle(
                          color: Colors.lightGreenAccent, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            height: size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton.icon(
                    onPressed: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => AddEvent(widget.uid)));
                    },
                    icon: Icon(
                      Icons.add,
                    ),
                    label: Text('Add'),
                    color: Colors.orangeAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          child: Icon(Icons.list),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return EventsMap(widget.uid);
                            }));
                          },
                          child: Container(
                            child: Icon(Icons.map),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<Event>>(
              stream: EventDatabaseService(uid: widget.uid)
                  .getEvents(sortValue, page),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  events = snapshot.data;
                  return Container(
                    height: size.height * 0.5,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return StreamBuilder<EventDetails>(
                            stream: EventDatabaseService(uid: widget.uid)
                                .getEventDetails(events[index].eventId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                details = snapshot.data;
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EventDisplay(
                                                  eid: events[index].eventId,
                                                  uid: widget.uid,
                                                )));
                                  },
                                  title: Text(details.eventName),
                                  subtitle: Text(details.dateOfEvent +
                                      " " +
                                      details.timeOfEvent),
                                );
                              } else {
                                return ListTile();
                              }
                            });
                      },
                      itemCount: events.length,
                    ),
                  );
                } else {
                  print(snapshot.error);
                  return Container(
                    child: Text('No Events'),
                  );
                }
              }),
        ],
      ),
    );
  }
}
