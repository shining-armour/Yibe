import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegesection/services/growth_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class GrowthDisplay extends StatefulWidget {
  final String growthType;
  final bool didAppliedBefore;
  final String uid;
  final DocumentSnapshot Details;

  GrowthDisplay({this.Details, this.growthType, this.uid, this.didAppliedBefore});

  @override
  _GrowthDisplayState createState() => _GrowthDisplayState();
}

class _GrowthDisplayState extends State<GrowthDisplay> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
 void initState(){
    print(widget.didAppliedBefore);
    super.initState();
  }

  launchProjectLink(url, var m, var l) async {
    print(url);
    print(m);
    print(l);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<void> sendResume() async {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                    widget.growthType!='Project' ? 'Send your resume to ${widget.Details.data()['CompanyName']}' : 'Send your resume for this project ?'),
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text('Confirm'),
                        color: Colors.green,
                        onPressed: () {
                          GrowthDatabaseService(uid: widget.uid).checkIfUserCreatedResume().then((value){
                            widget.growthType=='Internship' ? GrowthDatabaseService(uid: widget.uid).sendResumeDetailsToRecruiterForinternship(value, widget.Details.data()['id']) : widget.growthType=='QuickFix' ? GrowthDatabaseService(uid: widget.uid).sendResumeDetailsToRecruiterForQuickFix(value, widget.Details.data()['id']) : GrowthDatabaseService(uid: widget.uid).sendResumeDetailsToRecruiterForProject(value, widget.Details.data()['id']);
                          });
                         Navigator.pop(context);
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Your resume is sent!"),
                          ));
                        },
                      ),
                      FlatButton(
                          child: Text('Deny'),
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          }
                      ),
                    ]),
              ));
    }

     return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.growthType!='Project' ? widget.Details.data()['jobTitle'] : widget.Details.data()['projectTitle'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      widget.growthType!='Project' ? Text(widget.Details.data()['CompanyName']) : Container(),
                      widget.growthType=='Internship' ? Row(children: [
                        Icon(widget.Details.data()['employmentType']=='Work from home' ? Icons.home : Icons.watch_later_outlined),
                        Text(widget.Details.data()['employmentType'])
                      ]) : Container(),
                      widget.growthType!='Project' ? Column(
                        children: [
                          Row(children: [
                            Icon(Icons.calendar_today),
                            Text(widget.growthType=='Internship' ? widget.Details.data()['durationInMonths'].toString() + ' months' : widget.Details.data()['durationInHours'].toString() + ' hours')
                          ]),
                          Row(children: [
                            Icon(Icons.monetization_on_rounded),
                            Text(widget.growthType=='Internship' ? widget.Details.data()['stipendPerMonth'] != 0 ? widget.Details.data()['stipendPerMonth'].toString() + '/month'
                                : 'Unpaid' : widget.Details.data()['stipendInHours'] != 0 ? widget.Details.data()['stipendInHours'].toString() + ' per hour' : 'Unpaid')
                          ]),
                        ],
                      ) : Container(),
                      widget.growthType=='Internship' ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      Row(
                        children: [
                          Icon(Icons.label_important),
                          Text('Apply by ' +
                              widget.Details.data()['applyBy']),
                        ],
                      ),
                        Row(children: [
                          Text('No of openings: '),
                          Text(widget.Details.data()['NoOfOpenings'].toString())
                        ]),
                      ]) : Container(),
                      SizedBox(height: 20.0),
                      widget.growthType!='Project' ? Column(
                        children: [
                          Text(
                            'About The Company',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(widget.Details.data()['aboutCompany']),
                        ],
                      ) : Container(),
                      SizedBox(height: 20.0),
                      Text(
                        'Required Skills',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(widget.Details.data()['requiredSkills']),
                      SizedBox(height: 20.0),
                      Text(
                        widget.growthType!='Project' ? 'Work Description' : 'Project Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(widget.growthType!='Project' ? widget.Details.data()['jobDescription'] : widget.Details.data()['projectDescription']),
                      SizedBox(height: 20.0),
                      widget.growthType=='Internship' ? Column(
                        children: [
                          Text(
                            'Perks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(widget.Details.data()['perks']),
                        ],
                      ) : Container(),
                      SizedBox(height: 5.0,),
                     widget.growthType=='Project' ? Column(
                        children: [
                          Text(
                            'Existing Work',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(widget.Details.data()['existingWork']),
                          SizedBox(height: 10.0),
                          Text(
                            'Team Members',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(height: 5.0),
                          ListView.builder(
                            shrinkWrap: true,
                           itemCount: widget.Details.data()['teamMembers'].length,
                           itemBuilder: (context, i) {
                             return Text('${i+1}. ' + widget.Details.data()['teamMembers'][i], textAlign: TextAlign.center,);
                           }),
                        ],
                      ) : Container(),
                      SizedBox(height: 10.0,),
                      Text(
                        'Work Location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(widget.Details.data()['location']),
                      SizedBox(height: 10.0),
                      widget.growthType=='Project' ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.link),
                          SizedBox(width: 5.0,),
                          GestureDetector(
                            child: Text(
                              'Project Link',
                              style: TextStyle(decoration : TextDecoration.underline, fontSize: 15.0, color: Colors.blue),

                            ),
                            onTap: () => launchProjectLink(widget.Details.data()['projectLink'], widget.Details.data()['teamMembers'], widget.Details.data()['teamMembers'].length),
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                child: RaisedButton(
                  onPressed:widget.didAppliedBefore ? (){scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Your application is already sent"),
                  ));} : sendResume,
                  child: widget.didAppliedBefore ? Text('Applied') : Text('Apply'),
                  color: Colors.blue,
                ),
              ),
            );
          }
}