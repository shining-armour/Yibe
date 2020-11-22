import 'package:collegesection/models/Activity.dart';
import 'package:collegesection/screens/activities/activity_display.dart';
import 'package:collegesection/screens/activities/add_activity.dart';
import 'package:collegesection/screens/mapscreens/activity_map.dart';
import 'package:collegesection/services/activity_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityHome extends StatefulWidget {
  final String uid;

  const ActivityHome({this.uid});

  @override
  _ActivityHomeState createState() => _ActivityHomeState();
}

class _ActivityHomeState extends State<ActivityHome> {
  int sortValue = 2;
  int page = 0;
  List<Activity> activities = [];

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
      appBar: AppBar(
        title: Text('Activities'),
        actions: [
          FlatButton(
            child: Text('your activities'),
            onPressed: () {},
          ),
          FlatButton(
            child: Text('your requests'),
            onPressed: () {},
          ),
        ],
      ),
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
                      'Sports',
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
                      'E-sports',
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
                      'Skills+',
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
//                              builder: (BuildContext context) => AddActivity(
//                                    uid: widget.uid,
//                                  )));
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
                              return ActivityMap(
                                uid: widget.uid,
                              );
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
          Container(
            height: size.height * 0.7,
            child: StreamBuilder<List<Activity>>(
                stream: ActivityDatabaseService(uid: widget.uid)
                    .getActivities(sortValue, page),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    activities = snapshot.data;
                    return ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return StreamBuilder<ActivityDetails>(
                              stream: ActivityDatabaseService(uid: widget.uid)
                                  .getActivityDetails(
                                      activities[index].activityId,
                                      activities[index].activityType),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListTile(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return ActivityDisplay(
                                            uid: widget.uid,
                                            a: snapshot.data,
                                          );
                                        }));
                                      },
                                      title: Text(snapshot.data.activityTitle));
                                } else {
                                  print(snapshot.data);
                                  return ListTile();
                                }
                              });
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
