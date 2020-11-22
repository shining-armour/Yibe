import 'package:collegesection/screens/growth/growth_display.dart';
import 'package:collegesection/services/growth_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrowthHome extends StatefulWidget {
  final String uid;

  const GrowthHome({this.uid});

  @override
  _GrowthHomeState createState() => _GrowthHomeState();
}

class _GrowthHomeState extends State<GrowthHome> {
  int sortValue = 2;
  int page = 0;

  @override
  void initState() {
    super.initState();
  }

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
          title: Text('Growth'),
         /* actions: [
           FlatButton(
            child: Text('your applied'),
            onPressed: () {},
          ),
          FlatButton(
            child: Text('your requests'),
            onPressed: () {},
          ),
          ],*/
        ),
        body: ListView(children: [
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
                      'Internship',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 20.0),
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
                      'QuickFixes',
                      style:
                          TextStyle(color: Colors.amberAccent, fontSize: 20.0),
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
                      'Projects',
                      style: TextStyle(
                          color: Colors.lightGreenAccent, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5.0,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: page == 0 ? internshipsStream() : page == 1 ? quickFixStream() : projectStream()
          ),
    ]));
  }

  Widget internshipsStream(){
    return StreamBuilder(
        stream: GrowthDatabaseService(uid: widget.uid).getInternships(),
        builder: (context, snapshot) {
          //print(snapshot.data != null ? snapshot.data : 'Null');
          if (snapshot.hasData) {
            var internShips = snapshot.data.documents;
            return ListView.builder(
              itemCount: internShips.length,
              itemBuilder: (context, i) {
                bool didAppliedBefore=false;
                GrowthDatabaseService(uid: widget.uid).checkIfUserAppliedforThisInternship(internShips[i].data()['id']).then((value) => setState((){
                  didAppliedBefore = value;
                }));
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            Text(internShips[i].data()['jobTitle'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text(internShips[i]
                                .data()['CompanyName']),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 80,
                                    minHeight: 80,
                                    maxWidth: 80,
                                    maxHeight: 80,
                                  ),
                                  child: Image.asset(
                                      'images/random_logo.jpg',
                                      fit: BoxFit.cover),
                                ),
                                Column(children: [
                                  Row(children: [
                                    Icon(internShips[i].data()[
                                    'employmentType'] ==
                                        'Work from home'
                                        ? Icons.home
                                        : Icons
                                        .watch_later_outlined),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(internShips[i]
                                        .data()['employmentType'])
                                  ]),
                                  Row(
                                    children: [
                                      Row(children: [
                                        Icon(Icons.calendar_today),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        Text(internShips[i]
                                            .data()[
                                        'durationInMonths']
                                            .toString() +
                                            ' months')
                                      ]),
                                    ],
                                  ),
                                  Row(children: [
                                    Icon(Icons
                                        .monetization_on_rounded),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(internShips[i].data()[
                                    'stipendPerMonth'] !=
                                        0
                                        ? internShips[i]
                                        .data()[
                                    'stipendPerMonth']
                                        .toString() +
                                        '/month'
                                        : 'Unpaid')
                                  ]),
                                ]),
                              ],
                            ),
                            Row(children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 3.0,
                              ),
                              Text(internShips[i]
                                  .data()['location']
                                  .toString())
                            ]),
                            Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.label_important),
                                      Text('Apply by ' +
                                          internShips[i]
                                              .data()['applyBy']),
                                    ],
                                  ),
                                  FlatButton(
                                      color: Colors.orange,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                 GrowthDisplay(
                                                      didAppliedBefore: didAppliedBefore,
                                                      growthType: 'Internship',
                                                      uid: widget.uid,
                                                      Details: internShips[i],
                                                 ))),
                                      child: Text('Details'))
                                ]),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 10.0,
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Container(child: Text('Nothing to show')));
          } else {
            return Center(
                child: Container(child: Text('Nothing to show')));
          }
        });
  }

  Widget quickFixStream(){
    return StreamBuilder(
        stream: GrowthDatabaseService(uid: widget.uid)
            .getQuickFixes(),
        builder: (context, snapshot) {
          //print(snapshot.data != null ? snapshot.data : 'Null');
          if (snapshot.hasData) {
            var quickFixes = snapshot.data.documents;
            return ListView.builder(
              itemCount: quickFixes.length,
              itemBuilder: (context, i) {
                bool didAppliedBefore=false;
                GrowthDatabaseService(uid: widget.uid).checkIfUserAppliedforThisQuickFix(quickFixes[i].data()['id']).then((value) => setState((){
                  didAppliedBefore = value;
                }));
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(children: [
                          Text(quickFixes[i].data()['jobTitle'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(quickFixes[i]
                              .data()['CompanyName']),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 80,
                                    minHeight: 80,
                                    maxWidth: 80,
                                    maxHeight: 80,
                                  ),
                                  child: Image.asset(
                                      'images/random_logo.jpg',
                                      fit: BoxFit.cover),
                                ),
                                Column(children: [
                                  Row(children: [
                                    Icon(Icons.calendar_today),
                                    Text(quickFixes[i]
                                        .data()[
                                    'durationInHours']
                                        .toString() +
                                        ' hours')
                                  ]),
                                  Row(children: [
                                    Icon(Icons
                                        .monetization_on_rounded),
                                    Text(quickFixes[i].data()[
                                    'stipendInHours'] !=
                                        0
                                        ? quickFixes[i]
                                        .data()[
                                    'stipendInHours']
                                        .toString() +
                                        '/hour'
                                        : 'Unpaid')
                                  ]),
                                  Row(children: [
                                    Icon(Icons.location_on),
                                    Text(quickFixes[i]
                                        .data()['location']
                                        .toString())
                                  ]),
                                ]),
                              ]),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                  color: Colors.orange,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GrowthDisplay(
                                                  didAppliedBefore: didAppliedBefore,
                                                  Details: quickFixes[i],
                                                  growthType: 'QuickFix',
                                                  uid: widget.uid))),
                                  child: Text('Details')),
                              SizedBox(width: 5.0)
                            ],
                          ),
                        ]),
                      ),
                    ),
                    Divider(
                      height: 10.0,
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Container(child: Text('Nothing to show')));
          } else {
            return Center(
                child: Container(child: Text('Nothing to show')));
          }
        });
  }

  Widget projectStream(){
    return StreamBuilder(
        stream: GrowthDatabaseService(uid: widget.uid).getProjects(),
        builder: (context, snapshot) {
          //print(snapshot.data != null ? snapshot.data : 'Null');
          if (snapshot.hasData) {
            var projects = snapshot.data.documents;
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, i) {
                bool didAppliedBefore=false;
                GrowthDatabaseService(uid: widget.uid).checkIfUserAppliedforThisProject(projects[i].data()['id']).then((value) => setState((){
                  didAppliedBefore = value;
                }));
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(children: [
                          Text(
                              projects[i]
                                  .data()['projectTitle'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(projects[i]
                              .data()['projectDescription']),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 80,
                                    minHeight: 80,
                                    maxWidth: 80,
                                    maxHeight: 80,
                                  ),
                                  child: Image.asset(
                                      'images/random_logo.jpg',
                                      fit: BoxFit.cover),
                                ),
                                Column(children: [
                                  Row(children: [
                                    Text('Skills Needed:'),
                                    SizedBox(width: 3.0,),
                                    Text(projects[i]
                                        .data()['requiredSkills']
                                        .toString())
                                  ]),
                                  Row(children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 3.0,),
                                    Text(projects[i]
                                        .data()['location']
                                        .toString())
                                  ]),
                                ])
                              ]),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                    color: Colors.orange,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GrowthDisplay(
                                                  didAppliedBefore: didAppliedBefore,
                                                    Details: projects[i],
                                                    growthType:
                                                    'Project',
                                                    uid: widget
                                                        .uid))),
                                    child: Text('Details')),
                                SizedBox(width: 5.0,),
                              ]),
                        ]),
                      ),
                    ),
                    Divider(
                      height: 10.0,
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child:
                Container(child: Text('Nothing to show')));
          } else {
            return Center(
                child:
                Container(child: Text('Nothing to show')));
          }
        });
  }
}
