import 'package:collegesection/models/resume.dart';
import 'package:collegesection/services/growth_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyResume extends StatefulWidget {
  final String uid;

  MyResume({this.uid});

  @override
  _MyResumeState createState() => _MyResumeState();
}

class _MyResumeState extends State<MyResume> {

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController skills = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController projects = TextEditingController();
  int formErr = 0;
  bool didCreated = false;
  Map details;

  @override
  void initState(){
    super.initState();
    GrowthDatabaseService(uid: widget.uid).checkIfUserCreatedResume().then((value) => setState((){
        didCreated = true;
        details = value;
        fname.text = details['fname'];
        lname.text = details['lname'];
        phoneNumber.text = details['phoneNumber'];
        address.text = details['address'];
        skills.text = details['skills'];
        education.text = details['education'];
        projects.text = details['projects'];
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fname,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1.0)),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lime, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: lname,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.0)),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lime, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Phone Number :'),
            ),
            TextField(
              controller: phoneNumber,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Address :'),
            ),
            TextField(
              controller: address,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Education :'),
            ),
            TextField(
              controller: education,
               maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write about your degrees and year of completion',
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Skills :'),
            ),
            TextField(
              controller: skills,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Mentions your skills',
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Projects :'),
            ),
            TextField(
              controller: projects,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Mentions about your projects',
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lime, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            RaisedButton(
                child: !didCreated ? Text('Save Details') : Text('Edit Resume'),
              onPressed: !didCreated ? () async {
                if (fname.text != '' && lname.text != '' && address.text != '' && phoneNumber.text!='') {
                  didCreated=true;
                  ResumeDetails details = ResumeDetails(
                    fname: fname.text,
                    lname: lname.text,
                    address: address.text,
                    phoneNumber: phoneNumber.text,
                    skills: skills.text,
                    education: education.text,
                    projects: projects.text,
                    resumeId: widget.uid,
                  );
                  await GrowthDatabaseService(uid: widget.uid).addResumeDetails(details.toMap(details));
                } else {
                  setState(() {
                    formErr = 1;
                  });
                }
              } : () {
                setState(() {
                  didCreated = false;
                  fname.text='';
                  lname.text='';
                  skills.text='';
                  education.text='';
                  projects.text='';
                  address.text='';
                  phoneNumber.text='';
                });
              }
            ),
            formErr == 1
                ? Container(
              child: Text(
                'Please fill out the feilds',
                style: TextStyle(color: Colors.red),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}