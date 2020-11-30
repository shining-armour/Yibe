import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yibe_final_ui/services/resume_database.dart';

double screenWidth;

class Education {
  final String school;
  final String degree;
  final String field;
  final String startDate;
  final String endDate;
  final String grade;
  final String description;
  final String activity;
  final String image;
  Education(this.school, this.degree, this.field, this.startDate, this.endDate,
      this.grade, this.description, this.activity, this.image);
}

class Experience {
  final String title;
  final String type;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final String description;
  final String image;

  Experience(this.title, this.type, this.company, this.location, this.startDate,
      this.endDate, this.description, this.image);
}

//Experience exp;

class Achievement {
  final String title;
  final String code;
  final String description;
  final String link;
  final String date;
  final String image;

  Achievement(this.title, this.code, this.description, this.link, this.date,
      this.image);
}

class PersonalInfo {
  final String name;
  final int age;
  final String phoneNumber;
  final String city;
  final String add;
  final String email;
  final String linkedIn;
  final String twitter;

  PersonalInfo(this.name, this.age, this.phoneNumber, this.city, this.add,
      this.email, this.linkedIn, this.twitter);
}

// PersonalInfo personal;
class Resume extends StatefulWidget {
  @override
  _ResumeState createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  TextEditingController _SkillController = TextEditingController();
  TextEditingController _experTitleController = TextEditingController();
  TextEditingController _employmentTypeController = TextEditingController();
  TextEditingController _companyTypeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _experienceDesc = TextEditingController();
  TextEditingController _achieveTitle = TextEditingController();
  TextEditingController _achieveCode = TextEditingController();
  TextEditingController _achieveDescription = TextEditingController();
  TextEditingController _achieveLink = TextEditingController();
  TextEditingController _achievedate = TextEditingController();
  TextEditingController _eduSchool = TextEditingController();
  TextEditingController _edudegree = TextEditingController();
  TextEditingController __eduField = TextEditingController();
  TextEditingController _eduGrade = TextEditingController();
  TextEditingController _eduDescription = TextEditingController();
  TextEditingController _eduActivity = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _linkedIn = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  final picker = ImagePicker();
  int phoneCounter = 1, emailCounter = 1, socialAccountCounter = 1;
  File image;
  bool isLoading = true;
  var skillController = TextEditingController();
  var interestController = TextEditingController();
  String userName;
  String organiserId;
  String age, phone;
  String city;
  String add;
  String email;
  String linkedIn;
  String twitter;

  List<String> namesofSection = [
    'Personal Information',
    'Skills',
    'Interest',
    'Experience',
    'Education',
    'Achievement',
    'Yibe stats'
  ];
  var startDate = "";
  var endDate = "";
  List<String> skills = [];
  List<String> interest = [];
  List<Education> education = [];
  List<Achievement> achievement = [];
  bool isPresonalInfo = false;
  bool isSkills = false;
  bool isInterest = false;
  bool isExperience = false;
  bool isEducation = false;
  bool isAchivemnets = false;
  bool isYibe = false;
  static bool profileVisible = false;
  List<bool> valueofSection = [false, false, false, false, false, false, false];
  static bool isEditMode = false;
  List<String> btnSvgName = [
    'assets/images/download_btn.svg',
    'assets/images/viewpdf_btn.svg',
    'assets/images/lock_btn.svg',
    'assets/images/share_btn.svg',
  ];
  List<String> btnName = ['save', 'View PDF', 'Lock', 'Get Link'];
  List<Experience> experienceDetials = [];
  // 'Theisis Title: “Towards the Derridian Deconstruction of the Notion ‘Biography’ on the Basis of Julian Barnes 1984 novel ‘Flaubert’s Parrot’',
  // 'Dean’s List 2014-2016',
  // 'Assisted in hiring and managing a pool of freelancers as needed including developmennt edtors, copy editors, proofreaders, indexers, recpie tsters, and technical editors, including remote and on site employees',
  // 'President of the undergraduate student board from 2015 to 2016',
  // 'Assisted in the develpment, design, and preparation of sales materials.',
  // 'Provide generla and eqitoral support to the Stanford staff as requested',
  // ];
  List<Widget> expandedWidget = [
    Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Age : 19',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
              ),
              SizedBox(width: 50.0), //screenWidth * 0.2),
              Text(
                'City : Pune',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Text(
            'Address',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '7W Adams Street Stanford, CA 911234',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'Phone',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '1234567890',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'Email',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'richard.esward@gmail.com',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'LinkkedIn',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'richard.esward@gmail.com',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'Twitter',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'richard.esward@gmail.com',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Poppins',
            ),
          ),
          isEditMode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                        'Visibility',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: profileVisible,
                          activeColor: Color(0xff0CB5BB),
                          trackColor: Color(0xFFA7A7A7),
                          onChanged: (bool val) {
                            // setState(() {
                            //   profileVisible = val;
                            // });
                          },
                        ),
                      ),
                    ])
              : SizedBox(),
        ],
      ),
    ),
    Container(
      child: Text('hello'),
    ),
    Container(
      child: Text('hello'),
    ),
    // Container(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       ListView.builder(
    //                         shrinkWrap: true,
    //                         itemCount: experienceDetials.length,
    //                         itemBuilder: (BuildContext context,index){
    //                           return Dismissible(
    //                               key: UniqueKey(),
    //                               background: Container(color: Colors.red),
    //                               direction: isEditMode ?  DismissDirection.horizontal : null,
    //                               onDismissed: (DismissDirection direction){
    //                                 setState(() {
    //                                 experienceDetials.removeAt(index);
    //                               });},
    //                               child: ListTile(
    //                               leading: CircleAvatar(
    //                                     radius: 3.0,
    //                                     backgroundColor: Color(0xFF7280FF),
    //                               ),
    //                               title: Text(experienceDetials[index],
    //                                           style: TextStyle(
    //                                             fontSize: 16.0,
    //                                             fontFamily: 'Poppins'
    //                                           ),
    //                               ),
    //                             ),
    //                           );
    //                         }
    //                       ),
    //                       isEditMode ? Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Divider(
    //                             thickness: 1.0,
    //                             color: Colors.grey,
    //                           ),
    //                           Padding(
    //                         padding:  EdgeInsets.only(left:18.0,bottom: 5.0),
    //                         child: GestureDetector(
    //                           onTap: (){
    //                             showDialog(
    //                               context: context,
    //                               builder: (BuildContext context) {
    //                               return AlertDialog(
    //                                 title: Text('Add experience',
    //                                         style: TextStyle(
    //                                             color: Color(0xFF424283),
    //                                             fontSize: 16.0,
    //                                             fontFamily: 'Poppins',
    //                                           ),
    //                                       ),
    //                                 content: Text("Enter info here"),
    //                                 actions: [
    //                                     FlatButton(
    //                                         child: Text("ADD"),
    //                                         onPressed: () { },
    //                                     ),
    //                                   ],
    //                                 );
    //                               },
    //                             );
    //                           },
    //                           child: Text('Add experience',
    //                             style: TextStyle(
    //                             color: Color(0xFF424283),
    //                             fontSize: 20.0,
    //                             fontFamily: 'Poppins',
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                           Padding(
    //                         padding: EdgeInsets.only(left:18.0),
    //                         child: Text('Showcase your work experience ',
    //                               style: TextStyle(
    //                               fontSize: 16.0,
    //                               fontFamily: 'Poppins',
    //                               ),
    //                             ),
    //                       ),
    //                           Divider(
    //                         thickness: 1.0,
    //                         color: Colors.grey,
    //                       ),
    //                         ],
    //                       ) : SizedBox(),

    //                     ],
    //                   ),
    //                 ),
    // Container(child: Text('hello'),),
    Container(
      child: Text('hello'),
    ),
    Container(
      child: Text('hello'),
    ),
  ];
  String dropDownValue = 'Instagram';
  List<bool> isExpanded = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

/*String organiserId;
  int age, phone;
  String city;
  String  add ;
  String    email ;
  String    linkedIn ;
   String   twitter ; */
  void updateData() async {
    var userData = await ResumeDatabase().getUserDetail();

    userName = userData.docs[0].data()['userName'];
    organiserId = userData.docs[0].data()['organiserId'];
    age = userData.docs[0].data()['age'];
    phone = userData.docs[0].data()['phone'];
    city = userData.docs[0].data()['city'];
    add = userData.docs[0].data()['add'];
    email = userData.docs[0].data()['email'];
    linkedIn = userData.docs[0].data()['linkedIn'];
    twitter = userData.docs[0].data()['twitter'];

    var data = await ResumeDatabase().getData();
    data.docs.forEach((doc) {
      doc.data()['type'] == 'skills'
          ? skills.add(doc.data()['information'])
          : null;
      doc.data()['type'] == 'interset'
          ? interest.add(doc.data()['information'])
          : null;
      doc.data()['type'] == 'experence'
          ? experienceDetials.add(Experience(
              doc.data()['title'],
              doc.data()['type'],
              doc.data()['company'],
              doc.data()['location'],
              doc.data()['startDate'],
              doc.data()['endDate'],
              doc.data()['description'],
              doc.data()['image']))
          : null;
      doc.data()['type'] == 'education'
          ? education.add(Education(
              doc.data()['school'],
              doc.data()['degree'],
              doc.data()['field'],
              doc.data()['startDate'],
              doc.data()['endDate'],
              doc.data()['grade'],
              doc.data()['description'],
              doc.data()['activity'],
              doc.data()['image'],
            ))
          : null;
      doc.data()['type'] == 'achievement'
          ? achievement.add(Achievement(
              doc.data()['title'],
              doc.data()['code'],
              doc.data()['description'],
              doc.data()['link'],
              doc.data()['date'],
              doc.data()['image'],
            ))
          : null;
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
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
      body: isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resume',
                      style: TextStyle(
                        color: Color(0xFF0CB5BB),
                        fontSize: 32.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Color(0xFF424283),
                        fontSize: 32.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '@ $organiserId',
                      style: TextStyle(
                        color: Color(0xFFA7A7A7),
                        fontSize: 16.0,
                      ),
                    ),
                    // ListView.builder(
                    //   itemCount: namesofSection.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, i) {
                    //   return ExpansionTile(
                    //           onExpansionChanged: (val){ setState(() {
                    //             isExpanded[i] = !isExpanded[i];
                    //           });},
                    //           leading: SvgPicture.asset( isExpanded[i] ? 'assets/images/up_arrow.svg' : 'assets/images/down_arrow.svg',
                    //                               width: 14.0,
                    //                               height: 10.0,
                    //                     ),
                    //           trailing: isEditMode ? SvgPicture.asset('assets/images/edit_icon.svg',
                    //                                   width: 14.0,
                    //                                   height: 10.0,
                    //                     ): SizedBox(),
                    //           initiallyExpanded:  false,//(i==0)?true:false,
                    //           maintainState: true,
                    //           // title:  Text(questions.keys.elementAt(i)),
                    //           title:  Text(namesofSection.elementAt(i),
                    //                         style: TextStyle(
                    //                         color: Color(0xFF7280FF),
                    //                         fontSize: 20.0,
                    //                       ),
                    //                     ),
                    //           children: <Widget>[
                    //              Column(
                    //             children:[
                    //               ListTile(
                    //                 title: expandedWidget.elementAt(i),
                    //               ),
                    //            ],
                    //           ),
                    //         ],
                    //      );
                    //     },
                    // ),
/*personal*/ ResumeTopic(
                      key: UniqueKey(),
                      isEditMode: isEditMode,
                      onTapFunction: () {
                        setState(() {
                          isPresonalInfo = !isPresonalInfo;
                        });
                      },
                      topicName: 'Personal Information',
                      isVisible: isPresonalInfo,
                      dropdownContainer: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Age : age.toString()',
                                  style: TextStyle(
                                      fontSize: 16.0, fontFamily: 'Poppins'),
                                ),
                                SizedBox(width: screenWidth * 0.2),
                                Text(
                                  'City :',
                                  style: TextStyle(
                                      fontSize: 16.0, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              add,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              phone
                                  .toString(), //  personal.phoneNumber.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              email,
                              //    personal.email,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'LinkkedIn',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              linkedIn,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Twitter',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              twitter,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            isEditMode
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(
                                          'Visibility',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: 0.7,
                                          child: CupertinoSwitch(
                                            value: profileVisible,
                                            activeColor: Color(0xff0CB5BB),
                                            trackColor: Color(0xFFA7A7A7),
                                            onChanged: (bool val) {
                                              setState(() {
                                                profileVisible = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ])
                                : SizedBox(),
                            if (isEditMode)
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Add Personal Information',
                                          style: TextStyle(
                                            color: Color(0xFF424283),
                                            fontSize: 16.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                  controller: _userName,
                                                  decoration: InputDecoration(
                                                    hintText: 'Name',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                  )),
                                              SizedBox(height: 10.0),
                                              TextField(
                                                  controller: _id,
                                                  decoration: InputDecoration(
                                                    hintText: 'Organiser id',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                  )),
                                              SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.2,
                                                    child: TextField(
                                                        controller: _age,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Age',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xFF0CB5BB)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xFF0CB5BB)),
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(width: 20.0),
                                                  SizedBox(
                                                    width: screenWidth * 0.2,
                                                    child: TextField(
                                                        controller: _city,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'City',
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xFF0CB5BB)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xFF0CB5BB)),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.0),
                                              TextField(
                                                  controller: _address,
                                                  decoration: InputDecoration(
                                                    hintText: 'Address',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                  )),
                                              SizedBox(height: 10.0),
                                              SizedBox(
                                                height:
                                                    70.0, //70.0*phoneCounter,
                                                width: screenWidth,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: 1, //phoneCounter,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        TextField(
                                                            controller:
                                                                _phoneNumber,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Phone Number',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                            )),
                                                        SizedBox(height: 5.0),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (phoneCounter < 2) {
                                                      phoneCounter++;
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  '+ Add Phone',
                                                  style: TextStyle(
                                                    color: Color(0xFF424283),
                                                    fontSize: 16.0,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              SizedBox(
                                                height:
                                                    70.0, //70.0*emailCounter,
                                                width: screenWidth,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: 1, //emailCounter,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        TextField(
                                                            controller: _email,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'E-Mail',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                            )),
                                                        SizedBox(height: 5.0),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (emailCounter < 2) {
                                                      emailCounter++;
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  '+ Add E-mail',
                                                  style: TextStyle(
                                                    color: Color(0xFF424283),
                                                    fontSize: 16.0,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                  controller: _linkedIn,
                                                  decoration: InputDecoration(
                                                    hintText: 'LinkedIn',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                  )),
                                              SizedBox(height: 10.0),
                                              TextField(
                                                  controller: _twitter,
                                                  decoration: InputDecoration(
                                                    hintText: 'Twitter',
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xFF0CB5BB)),
                                                    ),
                                                  )),
                                            ],
                                            //                   children: [
                                            //                     TextField(
                                            //                       controller:
                                            //                                 _userName,
                                            //                                decoration:
                                            //                                   InputDecoration(
                                            //                                 hintText:
                                            //                                     'Name',
                                            //                                 hintStyle:
                                            //                                     TextStyle(
                                            //                                   color:
                                            //                                       Colors.grey,
                                            //                                 ),
                                            //                                 enabledBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                                 focusedBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                               )
                                            //                           ),
                                            //                     //       SizedBox(height: 10.0,),
                                            //                     //        TextField(
                                            //                     //         controller:
                                            //                     //             _id,
                                            //                     //            decoration:
                                            //                     //               InputDecoration(
                                            //                     //             hintText:
                                            //                     //                 'Organiser id',
                                            //                     //             hintStyle:
                                            //                     //                 TextStyle(
                                            //                     //               color:
                                            //                     //                   Colors.grey,
                                            //                     //             ),
                                            //                     //             enabledBorder:
                                            //                     //                 OutlineInputBorder(
                                            //                     //               borderRadius: BorderRadius
                                            //                     //                   .all(Radius
                                            //                     //                       .circular(
                                            //                     //                           10.0)),
                                            //                     //               borderSide: BorderSide(
                                            //                     //                   color: Color(
                                            //                     //                       0xFF0CB5BB)),
                                            //                     //             ),
                                            //                     //             focusedBorder:
                                            //                     //                 OutlineInputBorder(
                                            //                     //               borderRadius: BorderRadius
                                            //                     //                   .all(Radius
                                            //                     //                       .circular(
                                            //                     //                           10.0)),
                                            //                     //               borderSide: BorderSide(
                                            //                     //                   color: Color(
                                            //                     //                       0xFF0CB5BB)),
                                            //                     //             ),
                                            //                     //           )
                                            //                     //       ),
                                            //                     SizedBox(
                                            //                       height: 100.0,
                                            //                       width: 500.0,
                                            //                       child: Row(
                                            //                         children: [
                                            //                            TextField(
                                            //                               controller:
                                            //                                   _age,
                                            //                                  decoration:
                                            //                                     InputDecoration(
                                            //                                   hintText:
                                            //                                       'Age',
                                            //                                   hintStyle:
                                            //                                       TextStyle(
                                            //                                     color:
                                            //                                         Colors.grey,
                                            //                                   ),
                                            //                                   enabledBorder:
                                            //                                       OutlineInputBorder(
                                            //                                     borderRadius: BorderRadius
                                            //                                         .all(Radius
                                            //                                             .circular(
                                            //                                                 10.0)),
                                            //                                     borderSide: BorderSide(
                                            //                                         color: Color(
                                            //                                             0xFF0CB5BB)),
                                            //                                   ),
                                            //                                   focusedBorder:
                                            //                                       OutlineInputBorder(
                                            //                                     borderRadius: BorderRadius
                                            //                                         .all(Radius
                                            //                                             .circular(
                                            //                                                 10.0)),
                                            //                                     borderSide: BorderSide(
                                            //                                         color: Color(
                                            //                                             0xFF0CB5BB)),
                                            //                                   ),
                                            //                                 )
                                            //                             ),
                                            //                           SizedBox(width: 30.0),
                                            //                           SizedBox(
                                            //                             width: 70.0,
                                            //                             child:  TextField(
                                            //                               controller:
                                            //                                   _city,
                                            //                                  decoration:
                                            //                                     InputDecoration(
                                            //                                   hintText:
                                            //                                       'City',
                                            //                                   hintStyle:
                                            //                                       TextStyle(
                                            //                                     color:
                                            //                                         Colors.grey,
                                            //                                   ),
                                            //                                   enabledBorder:
                                            //                                       OutlineInputBorder(
                                            //                                     borderRadius: BorderRadius
                                            //                                         .all(Radius
                                            //                                             .circular(
                                            //                                                 10.0)),
                                            //                                     borderSide: BorderSide(
                                            //                                         color: Color(
                                            //                                             0xFF0CB5BB)),
                                            //                                   ),
                                            //                                   focusedBorder:
                                            //                                       OutlineInputBorder(
                                            //                                     borderRadius: BorderRadius
                                            //                                         .all(Radius
                                            //                                             .circular(
                                            //                                                 10.0)),
                                            //                                     borderSide: BorderSide(
                                            //                                         color: Color(
                                            //                                             0xFF0CB5BB)),
                                            //                                   ),
                                            //                                 )
                                            //                             ),
                                            //                           ),
                                            //                         ],
                                            //                       ),
                                            //                     ),
                                            //                    TextField(
                                            //                             controller:
                                            //                                 _address,
                                            //                                decoration:
                                            //                                   InputDecoration(
                                            //                                 hintText:
                                            //                                     'Address',
                                            //                                 hintStyle:
                                            //                                     TextStyle(
                                            //                                   color:
                                            //                                       Colors.grey,
                                            //                                 ),
                                            //                                 enabledBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                                 focusedBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                               )
                                            //                           ),
                                            //   // SizedBox(
                                            //   //   height: 100.0,
                                            //   //   width: screenWidth,
                                            //   //   child: ListView.builder(
                                            //   //   shrinkWrap: true,
                                            //   //   itemCount: phoneCounter,
                                            //   //   itemBuilder: (context,index){
                                            //   //     return TextField(
                                            //   //                             controller:
                                            //   //                                 _phoneNumber,
                                            //   //                                decoration:
                                            //   //                                   InputDecoration(
                                            //   //                                 hintText:
                                            //   //                                     'Phone Number',
                                            //   //                                 hintStyle:
                                            //   //                                     TextStyle(
                                            //   //                                   color:
                                            //   //                                       Colors.grey,
                                            //   //                                 ),
                                            //   //                                 enabledBorder:
                                            //   //                                     OutlineInputBorder(
                                            //   //                                   borderRadius: BorderRadius
                                            //   //                                       .all(Radius
                                            //   //                                           .circular(
                                            //   //                                               10.0)),
                                            //   //                                   borderSide: BorderSide(
                                            //   //                                       color: Color(
                                            //   //                                           0xFF0CB5BB)),
                                            //   //                                 ),
                                            //   //                                 focusedBorder:
                                            //   //                                     OutlineInputBorder(
                                            //   //                                   borderRadius: BorderRadius
                                            //   //                                       .all(Radius
                                            //   //                                           .circular(
                                            //   //                                               10.0)),
                                            //   //                                   borderSide: BorderSide(
                                            //   //                                       color: Color(
                                            //   //                                           0xFF0CB5BB)),
                                            //   //                                 ),
                                            //   //                               )
                                            //   //                           );
                                            //   //   },
                                            //   //   ),
                                            //   // ),
                                            // GestureDetector(
                                            //     onTap: (){
                                            //       setState(() {
                                            //         if(phoneCounter<=2){
                                            //           phoneCounter++;
                                            //         }
                                            //       });
                                            //     },
                                            //     child: Text('+ Add Phone',
                                            //     style: TextStyle(
                                            //         color: Color(0xFF424283),
                                            //         fontSize: 16.0,
                                            //         fontFamily: 'Poppins',
                                            //         fontWeight: FontWeight.w500,
                                            //       ),
                                            //   ),
                                            // ),

                                            //                     // GestureDetector(
                                            //                     //   onTap: () {},
                                            //                     //   child: Text(
                                            //                     //     '+ Add Phone',
                                            //                     //     style: TextStyle(
                                            //                     //       color:
                                            //                     //           Color(0xFF424283),
                                            //                     //       fontSize: 16.0,
                                            //                     //       fontFamily: 'Poppins',
                                            //                     //       fontWeight:
                                            //                     //           FontWeight.w500,
                                            //                     //     ),
                                            //                     //   ),
                                            //                     // ),
                                            //                     SizedBox(height: 10.0),
                                            //                    TextField(
                                            //                             controller:
                                            //                                 _email,
                                            //                                decoration:
                                            //                                   InputDecoration(
                                            //                                 hintText:
                                            //                                     'E-Mail',
                                            //                                 hintStyle:
                                            //                                     TextStyle(
                                            //                                   color:
                                            //                                       Colors.grey,
                                            //                                 ),
                                            //                                 enabledBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                                 focusedBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                               )
                                            //                           ),

                                            //                     SizedBox(height: 10.0),
                                            //                     TextField(
                                            //                             controller:
                                            //                                 _linkedIn,
                                            //                                decoration:
                                            //                                   InputDecoration(
                                            //                                 hintText:
                                            //                                     'LinkedIn',
                                            //                                 hintStyle:
                                            //                                     TextStyle(
                                            //                                   color:
                                            //                                       Colors.grey,
                                            //                                 ),
                                            //                                 enabledBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                                 focusedBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                               )
                                            //                           ),
                                            //                           SizedBox(height:10.0),
                                            //                     TextField(
                                            //                             controller:
                                            //                                 _twitter,
                                            //                                decoration:
                                            //                                   InputDecoration(
                                            //                                 hintText:
                                            //                                     'Twitter',
                                            //                                 hintStyle:
                                            //                                     TextStyle(
                                            //                                   color:
                                            //                                       Colors.grey,
                                            //                                 ),
                                            //                                 enabledBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                                 focusedBorder:
                                            //                                     OutlineInputBorder(
                                            //                                   borderRadius: BorderRadius
                                            //                                       .all(Radius
                                            //                                           .circular(
                                            //                                               10.0)),
                                            //                                   borderSide: BorderSide(
                                            //                                       color: Color(
                                            //                                           0xFF0CB5BB)),
                                            //                                 ),
                                            //                               )
                                            //                           ),
                                            //                     // Row(
                                            //                     //   children: [
                                            //                         // SizedBox(
                                            //                         //   width: MediaQuery.of(
                                            //                         //               context)
                                            //                         //           .size
                                            //                         //           .width *
                                            //                         //       0.3,
                                            //                         //   child: TextBox(
                                            //                         //       controller:
                                            //                         //           skillController,
                                            //                         //       hintTxt:
                                            //                         //           'Socials link',
                                            //                         //       maxLine: 1),
                                            //                         // ),
                                            //                        // SizedBox(width: 30.0),
                                            //                         // SizedBox(
                                            //                         //   width: MediaQuery.of(
                                            //                         //               context)
                                            //                         //           .size
                                            //                         //           .width *
                                            //                         //       0.3,
                                            //                         //   child: DropdownButton(
                                            //                         //     value: dropDownValue,
                                            //                         //     items: [
                                            //                         //       DropdownMenuItem(
                                            //                         //         value:
                                            //                         //             'Instagram',
                                            //                         //         child: Text(
                                            //                         //           'Instagram',
                                            //                         //           style:
                                            //                         //               TextStyle(
                                            //                         //             fontSize:
                                            //                         //                 14.0,
                                            //                         //             fontFamily:
                                            //                         //                 'Poppins',
                                            //                         //           ),
                                            //                         //         ),
                                            //                         //       ),
                                            //                         //       DropdownMenuItem(
                                            //                         //         value: 'Twitter',
                                            //                         //         child: Text(
                                            //                         //           'Twitter',
                                            //                         //           style:
                                            //                         //               TextStyle(
                                            //                         //             fontSize:
                                            //                         //                 14.0,
                                            //                         //             fontFamily:
                                            //                         //                 'Poppins',
                                            //                         //           ),
                                            //                         //         ),
                                            //                         //       ),
                                            //                         //       DropdownMenuItem(
                                            //                         //         value: 'Facebook',
                                            //                         //         child: Text(
                                            //                         //           'Facebook',
                                            //                         //           style:
                                            //                         //               TextStyle(
                                            //                         //             fontSize:
                                            //                         //                 14.0,
                                            //                         //             fontFamily:
                                            //                         //                 'Poppins',
                                            //                         //           ),
                                            //                         //         ),
                                            //                         //       ),
                                            //                         //     ],
                                            //                         //     onChanged: (value) {
                                            //                         //       setState(() {
                                            //                         //         dropDownValue =
                                            //                         //             value;
                                            //                         //       });
                                            //                         //     },
                                            //                         //   ),
                                            //                         // ),
                                            //                     //   ],
                                            //                     // ),
                                            //                     SizedBox(height: 10.0),
                                            //                     // GestureDetector(
                                            //                     //   onTap: () {},
                                            //                     //   child: Text(
                                            //                     //     '+ Add Social',
                                            //                     //     style: TextStyle(
                                            //                     //       color:
                                            //                     //           Color(0xFF424283),
                                            //                     //       fontSize: 16.0,
                                            //                     //       fontFamily: 'Poppins',
                                            //                     //       fontWeight:
                                            //                     //           FontWeight.w500,
                                            //                     //     ),
                                            //                     //   ),
                                            //                     // ),
                                            //                   ],
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color(0xFF0CB5BB),
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(width: screenWidth * 0.1),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                            onPressed: () {
                                              ResumeDatabase()
                                                  .addPersonalDetail(
                                                      _userName.text,
                                                      _id.text,
                                                      _age.text,
                                                      _phoneNumber.text,
                                                      _city.text,
                                                      _address.text,
                                                      _email.text,
                                                      _linkedIn.text,
                                                      _twitter.text);
                                              setState(() {});
                                              Navigator.pop(context);
                                              updateData();
                                            },
                                            color: Color(0xFF0CB5BB),
                                            textColor: Colors.white,
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.05),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Add Personal Information',
                                  style: TextStyle(
                                    color: Color(0xFF424283),
                                    fontSize: 20.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                            else
                              SizedBox(),
                          ],
                        ),
                      ),
                    ),
/*skills*/ ResumeTopic(
                        key: UniqueKey(),
                        isEditMode: isEditMode,
                        onTapFunction: () {
                          setState(() {
                            isSkills = !isSkills;
                          });
                        },
                        topicName: 'Skills',
                        isVisible: isSkills,
                        dropdownContainer: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemCount: skills.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF424283),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    skills[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                            isEditMode
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Add Skills',
                                              style: TextStyle(
                                                color: Color(0xFF424283),
                                                fontSize: 16.0,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: SizedBox(
                                                width: screenWidth * 8,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _SkillController,
                                                      maxLines: 3,
                                                      minLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Type in skills',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 5.0,
                                                        mainAxisSpacing: 5.0,
                                                      ),
                                                      itemCount: skills.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: 10.0,
                                                          height: 30.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF424283),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                skills[index],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     setState(() {
                                                              //       skills.removeAt(
                                                              //           index);
                                                              //     });
                                                              //   },
                                                              //   child: SvgPicture.asset(
                                                              //       'assets/images/close_btn.svg',
                                                              //       width: 22.0,
                                                              //       height:
                                                              //           22.0),
                                                              // ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(
                                                  'Cancle',
                                                  style: TextStyle(
                                                    color: Color(0xFF0CB5BB),
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.1),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                onPressed: () async {
                                                  await ResumeDatabase()
                                                      .addSkill(_SkillController
                                                          .text);
                                                  _SkillController.clear();
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  updateData();
                                                },
                                                color: Color(0xFF0CB5BB),
                                                textColor: Colors.white,
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.05),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Add Skills',
                                      style: TextStyle(
                                        color: Color(0xFF424283),
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
/*interest*/ ResumeTopic(
                        key: UniqueKey(),
                        isEditMode: isEditMode,
                        onTapFunction: () {
                          setState(() {
                            isInterest = !isInterest;
                          });
                        },
                        topicName: 'Interest',
                        isVisible: isInterest,
                        dropdownContainer: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                              itemCount: interest.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 10.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF424283),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    interest[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                            isEditMode
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Add interests',
                                              style: TextStyle(
                                                color: Color(0xFF424283),
                                                fontSize: 16.0,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: SizedBox(
                                                width: screenWidth * 8,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          interestController,
                                                      maxLines: 3,
                                                      minLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Type in interests',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          interest.length,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 5.0,
                                                        mainAxisSpacing: 5.0,
                                                      ),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: 130.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF424283),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                interest[index],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              // GestureDetector(
                                                              //   onTap: () {
                                                              //     setState(() {
                                                              //       interest
                                                              //           .removeAt(
                                                              //               index);
                                                              //     });
                                                              //   },
                                                              //   child: SvgPicture.asset(
                                                              //       'assets/images/close_btn.svg',
                                                              //       width: 22.0,
                                                              //       height:
                                                              //           22.0),
                                                              // ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(
                                                  'Cancle',
                                                  style: TextStyle(
                                                    color: Color(0xFF0CB5BB),
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.1),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                onPressed: () {
                                                  setState(() async {
                                                    await ResumeDatabase()
                                                        .addInterest(
                                                            interestController
                                                                .text);
                                                    interest.add(
                                                        interestController
                                                            .text);
                                                    interestController.clear();
                                                    Navigator.pop(context);
                                                    updateData();
                                                  });
                                                },
                                                color: Color(0xFF0CB5BB),
                                                textColor: Colors.white,
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.05),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Add Interest',
                                      style: TextStyle(
                                        color: Color(0xFF424283),
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
/*experience*/ ResumeTopic(
                      key: UniqueKey(),
                      isEditMode: isEditMode,
                      onTapFunction: () {
                        setState(() {
                          isExperience = !isExperience;
                        });
                      },
                      isVisible: isExperience,
                      topicName: 'Experience',
                      dropdownContainer: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: experienceDetials.length,
                                itemBuilder: (BuildContext context, index) {
                                  Experience exp = experienceDetials[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    background: Container(color: Colors.red),
                                    direction: isEditMode
                                        ? DismissDirection.horizontal
                                        : null,
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        experienceDetials.removeAt(index);
                                      });
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Image.network(
                                          exp.image,
                                          fit: BoxFit.contain,
                                        ),
                                        radius: 30.0,
                                        backgroundColor: Colors.white,
                                      ),
                                      title: Column(
                                        children: [
                                          Text(
                                            exp.title,
                                            //     exp.title,// experienceDetials[index],
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'timeline', // timeline,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFA7A7A7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        // experienceDetials[index],
                                        exp.description, // discription,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            isEditMode
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0, bottom: 5.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Add Experince',
                                                    style: TextStyle(
                                                      color: Color(0xFF424283),
                                                      fontSize: 16.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    // _experTitleController.text,
                                                    // _employmentTypeController
                                                    //     .text,
                                                    // _companyTypeController.text,
                                                    // _locationController.text,
                                                    // startDate,
                                                    // endDate,
                                                    // _experienceDesc.text,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                            controller:
                                                                _experTitleController,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: 'Title',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                            )),
                                                        TextField(
                                                            controller:
                                                                skillController,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Employment type',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF0CB5BB)),
                                                              ),
                                                            )),
                                                        TextField(
                                                          controller:
                                                              _companyTypeController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Company Name',
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                          ),
                                                        ),
                                                        TextField(
                                                          controller:
                                                              _locationController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Location',
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            FlatButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                                side:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Start Date',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                _selectDate(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                                side:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'End Date',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                _selectDate(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.0),
                                                        TextField(
                                                          controller:
                                                              _experienceDesc,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Description',
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB)),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FlatButton(
                                                              height: 86.0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                                side:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                ),
                                                              ),
                                                              child: SizedBox(
                                                                width: 70.0,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '+',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF0CB5BB),
                                                                        fontSize:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5.0),
                                                                    SizedBox(
                                                                      width:
                                                                          56.0,
                                                                      child:
                                                                          Text(
                                                                        'Add media',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF0CB5BB),
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                getImage();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(
                                                        'Cancle',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF0CB5BB),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.1),
                                                    RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      ),
                                                      onPressed: () async {
                                                        print("hello");
                                                        await ResumeDatabase()
                                                            .addExperienceDetials(
                                                                _experTitleController
                                                                    .text,
                                                                _employmentTypeController
                                                                    .text,
                                                                _companyTypeController
                                                                    .text,
                                                                _locationController
                                                                    .text,
                                                                startDate,
                                                                endDate,
                                                                _experienceDesc
                                                                    .text,
                                                                image);
                                                        print(
                                                            "experience added");
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                        updateData();
                                                      },
                                                      color: Color(0xFF0CB5BB),
                                                      textColor: Colors.white,
                                                      child: Text(
                                                        "Save",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.05),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Add experience',
                                            style: TextStyle(
                                              color: Color(0xFF424283),
                                              fontSize: 20.0,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 18.0),
                                        child: Text(
                                          'Showcase your work experience ',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
/*education*/ ResumeTopic(
                        key: UniqueKey(),
                        isEditMode: isEditMode,
                        onTapFunction: () {
                          setState(() {
                            isEducation = !isEducation;
                          });
                        },
                        topicName: 'Education',
                        isVisible: isEducation,
                        dropdownContainer: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: experienceDetials.length,
                                itemBuilder: (BuildContext context, index) {
                                  Experience exp = experienceDetials[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    background: Container(color: Colors.red),
                                    direction: isEditMode
                                        ? DismissDirection.horizontal
                                        : null,
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        experienceDetials.removeAt(index);
                                      });
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Image.network(
                                          exp.image,
                                          fit: BoxFit.contain,
                                        ),
                                        radius: 30.0,
                                        backgroundColor: Colors.white,
                                      ),
                                      title: Column(
                                        children: [
                                          Text(
                                            exp.title,
                                            //     exp.title,// experienceDetials[index],
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'timeline', // timeline,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFA7A7A7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        // experienceDetials[index],
                                        exp.description, // discription,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            isEditMode
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Add Education',
                                              style: TextStyle(
                                                color: Color(0xFF424283),
                                                fontSize: 16.0,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextBox(
                                                      controller:
                                                          skillController,
                                                      hintTxt:
                                                          'School / Colledge',
                                                      maxLine: 1),
                                                  TextBox(
                                                      controller:
                                                          skillController,
                                                      hintTxt: 'Dgree',
                                                      maxLine: 1),
                                                  TextBox(
                                                      controller:
                                                          skillController,
                                                      hintTxt: 'Field of study',
                                                      maxLine: 1),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      FlatButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Start Date',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0CB5BB),
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _selectDate(context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'End Date',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0CB5BB),
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _selectDate(context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  TextField(
                                                      controller: _eduGrade,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Grade',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  TextField(
                                                      controller:
                                                          _eduDescription,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: ' Desciption',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  TextField(
                                                      controller: _eduActivity,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Activity',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF0CB5BB)),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      FlatButton(
                                                        height: 86.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB),
                                                          ),
                                                        ),
                                                        child: SizedBox(
                                                          width: 70.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '+',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 5.0),
                                                              SizedBox(
                                                                width: 56.0,
                                                                child: Text(
                                                                  'Add media',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF0CB5BB),
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          getImage();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(
                                                  'Cancle',
                                                  style: TextStyle(
                                                    color: Color(0xFF0CB5BB),
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.1),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                onPressed: () async {
                                                  ResumeDatabase().addEducation(
                                                      _eduSchool.text,
                                                      _edudegree.text,
                                                      __eduField.text,
                                                      startDate,
                                                      endDate,
                                                      _eduGrade.text,
                                                      _eduDescription.text,
                                                      _eduActivity.text,
                                                      image);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  updateData();
                                                },
                                                color: Color(0xFF0CB5BB),
                                                textColor: Colors.white,
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.05),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Add Education',
                                      style: TextStyle(
                                        color: Color(0xFF424283),
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
                    ResumeTopic(
                      key: UniqueKey(),
                      isEditMode: isEditMode,
                      onTapFunction: () {
                        setState(() {
                          isAchivemnets = !isAchivemnets;
                        });
                      },
                      topicName: 'Achievements',
                      isVisible: isAchivemnets,
                      dropdownContainer: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Feb 2017',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      '2016 Drue Heinz Literature Prize',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 7.0),
                                  ],
                                ),
                              );
                            },
                          ),
                          isEditMode
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Add Achievement',
                                            style: TextStyle(
                                              color: Color(0xFF424283),
                                              fontSize: 16.0,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextField(
                                                    controller: _achieveTitle,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Achievement Title',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                TextField(
                                                    controller: _achieveCode,
                                                    decoration: InputDecoration(
                                                      hintText: 'Auth code',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                TextField(
                                                    controller:
                                                        _achieveDescription,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Achievement Desciption',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                TextField(
                                                    controller: _achieveLink,
                                                    decoration: InputDecoration(
                                                      hintText: 'Link',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF0CB5BB)),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    FlatButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0CB5BB),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Issue Date',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF0CB5BB),
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _selectDate(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    FlatButton(
                                                      height: 86.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xFF0CB5BB),
                                                        ),
                                                      ),
                                                      child: SizedBox(
                                                        width: 70.0,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '+',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF0CB5BB),
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 5.0),
                                                            SizedBox(
                                                              width: 56.0,
                                                              child: Text(
                                                                'Add media',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF0CB5BB),
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        getImage();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                'Cancle',
                                                style: TextStyle(
                                                  color: Color(0xFF0CB5BB),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(width: screenWidth * 0.1),
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                              onPressed: () async {
                                                await ResumeDatabase()
                                                    .addAchivement(
                                                        _achieveTitle.text,
                                                        _achieveCode.text,
                                                        _achieveDescription
                                                            .text,
                                                        _achieveLink.text,
                                                        _achievedate.text,
                                                        image);
                                                setState(() {});
                                                Navigator.pop(context);
                                                updateData();
                                              },
                                              color: Color(0xFF0CB5BB),
                                              textColor: Colors.white,
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.05),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Add Achievments',
                                    style: TextStyle(
                                      color: Color(0xFF424283),
                                      fontSize: 20.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    // ResumeTopic(
                    //         key: UniqueKey(),
                    //       isEditMode: isEditMode,
                    //       onTapFunction: (){
                    //         setState(() {
                    //           isYibe = !isYibe;
                    //         });
                    //       },
                    //       topicName: 'Yibe Stats ',
                    //       isVisible: isYibe,
                    //       dropdownContainer: Container(child: Text('Yibe stats'),),
                    //   ),
                    isEditMode
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24.0, 5.0, 0.0, 5.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                '+ Add Section',
                                style: TextStyle(
                                  color: Color(0xFF424283),
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10.0),
                    isEditMode
                        ? Padding(
                            padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width) * 0.2),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/images/download_btn.svg',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Text(
                                      'save',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Color(0xFF7280FF),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/images/viewpdf_btn.svg',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Text(
                                      'View PDF',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Color(0xFF7280FF),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/images/lock_btn.svg',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Text(
                                      'Lock',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Color(0xFF7280FF),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 15.0),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/images/share_btn.svg',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                    Text(
                                      'Get Link',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Color(0xFF7280FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditMode = !isEditMode;
          });
        },
        child: Icon(isEditMode ? Icons.close : Icons.edit,
            color: Color(0xFF7280FF)),
        backgroundColor: Colors.white,
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}

class TextBox extends StatelessWidget {
  const TextBox({Key key, this.controller, this.hintTxt, this.maxLine})
      : super(key: key);

  final TextEditingController controller;
  final String hintTxt;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          // controller: controller,
          maxLines: maxLine,
          // minLines: 0,
          decoration: InputDecoration(
            hintText: hintTxt,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFF0CB5BB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xFF0CB5BB)),
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}

class ResumeTopic extends StatefulWidget {
  const ResumeTopic(
      {Key key,
      this.isEditMode,
      this.onTapFunction,
      this.topicName,
      this.isVisible,
      this.dropdownContainer})
      : super(key: key);

  final bool isEditMode, isVisible;
  final Function onTapFunction;
  final String topicName;
  final Widget dropdownContainer;
  @override
  _ResumeTopicState createState() => _ResumeTopicState();
}

class _ResumeTopicState extends State<ResumeTopic> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onTapFunction,
            child: Row(children: [
              SvgPicture.asset(
                widget.isVisible
                    ? 'assets/images/up_arrow.svg'
                    : 'assets/images/down_arrow.svg',
                width: 14.0,
                height: 10.0,
              ),
              SizedBox(width: 5.0),
              Text(
                widget.topicName,
                style: TextStyle(
                  color: Color(0xFF7280FF),
                  fontSize: 20.0,
                ),
              ),
            ]),
          ),
          widget.isVisible ? widget.dropdownContainer : SizedBox(),
        ],
      ),
    );
  }
}

// dynamic topic list
//         SizedBox(
//   width: MediaQuery.of(context).size.width,
//     child: ListView.builder(
//     itemCount: namesofSection.length,
//     shrinkWrap: true,
//     itemBuilder: (BuildContext context,index){
//       return Padding(
//         padding:  EdgeInsets.symmetric(vertical: 8.0),
//         child: GestureDetector(
//           onTap: (){
//             setState(() {
//             });
//           },
//           child: Row(
//             children:[
//               SvgPicture.asset('assets/images/down_arrow.svg',
//                               width: 14.0,
//                               height: 10.0,
//               ),
//               SizedBox(width:5.0),
//               Text(namesofSection[index],
//                   style: TextStyle(
//                     color: Color(0xFF7280FF),
//                     fontSize: 20.0,
//                   ),
//               ),
//               Spacer(),
//               isEditMode ? SvgPicture.asset('assets/images/edit_icon.svg',
//                               width: 14.0,
//                               height: 10.0,
//               ): SizedBox(),
//             ]
//           ),

//         ),
//       );
//     }
//     ),
// ),
// dynamicedit menu
// isEditMode ? Center(
//   child: SizedBox(
//           height: 60.0,
//           width: 300.0,
//           child: Row(
//           children: [
//             ListView.builder(
//             itemCount: btnName.length,
//             itemBuilder: (BuildContext context, index){
//               return Column(
//                   children: [
//                     SvgPicture.asset($btnSvgName[index],
//                                     width: 40.0,
//                                     height: 40.0,
//                     ),
//                     Text(btnName[index],
//                         style: TextStyle(
//                           fontSize: 8.0,
//                           color: Color(0xFF7280FF),
//                         ),
//                     ),
//                   ],
//                 );
//             }
//            ),
//           ],
//         ),
//   ),
// ) : SizedBox(),
/*
            SizedBox(
                height: (MediaQuery.of(context).size.height),
                child: ReorderableListView(
                scrollDirection: Axis.vertical,
                key: UniqueKey(),
                children: [
                  ResumeTopic(
                  key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isPresonalInfo = !isPresonalInfo;
                    });
                  },
                  topicName: 'Personal Information',
                  isVisible: isPresonalInfo,
                  dropdownContainer: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Age : $age',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins'
                                ),
                            ),
                            SizedBox(width:  screenWidth * 0.2),
                            Text('City : $city',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins'
                                ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text('Address',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                        ),
                        SizedBox(height: 5.0),
                        Text(add,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                ),
                        ),
                        SizedBox(height: 12.0),
                        Text('Phone',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                        ),
                        SizedBox(height: 5.0),
                        Text(phone.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                ),
                        ),
                        SizedBox(height: 12.0),
                        Text('Email',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                        ),
                        SizedBox(height: 5.0),
                        Text(email,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                ),
                        ),
                        SizedBox(height: 12.0),
                        Text('LinkkedIn',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                        ),
                        SizedBox(height: 5.0),
                        Text(LinkedIn,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                ),
                        ),
                        SizedBox(height: 12.0),
                        Text('Twitter',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                        ),
                        SizedBox(height: 5.0),
                        Text(Twitter,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                ),
                        ),
                        isEditMode ?  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Visibility',
                                  style: TextStyle(fontSize: 16.0,fontFamily: 'Poppins',),
                                ),
                                Transform.scale(
                                    scale: 0.7,
                                    child: CupertinoSwitch(
                                      value: profileVisible,
                                      activeColor: Color(0xff0CB5BB),
                                      trackColor: Color(0xFFA7A7A7),
                                      onChanged: (bool val) {
                                        setState(() {
                                          profileVisible = val;
                                        });
                                      },
                                    ),
                                  ),

                              ]) : SizedBox() ,
                      ],
                    ),
                  ),
              ),
                  ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isSkills = !isSkills;
                    });
                  },
                  topicName: 'Skills',
                  isVisible: isSkills,
                  dropdownContainer: Container(child: Text('Skills'),),
              ),
                  ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isInterest = !isInterest;
                    });
                  },
                  topicName: 'Interest',
                  isVisible: isInterest,
                  dropdownContainer: Container(child: Text('Interest'),),
              ),
/*experience*/    ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isExperience = !isExperience;
                    });
                  },
                  isVisible: isExperience,
                  topicName: 'Experience',
                  dropdownContainer: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: experienceDetials.length,
                            itemBuilder: (BuildContext context,index){
                              return Dismissible(
                                  key: UniqueKey(),
                                  background: Container(color: Colors.red),
                                  direction: isEditMode ?  DismissDirection.horizontal : null,
                                  onDismissed: (DismissDirection direction){
                                    setState(() {
                                    experienceDetials.removeAt(index);
                                  });},
                                  child: ListTile(
                                  leading: CircleAvatar(
                                        radius: 3.0,
                                        backgroundColor: Color(0xFF7280FF),
                                  ),
                                  title: Text(experienceDetials[index],
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Poppins'
                                              ),
                                  ),
                                ),
                              );
                            }
                          ),
                          isEditMode ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              Padding(
                            padding:  EdgeInsets.only(left:18.0,bottom: 5.0),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Add experience',
                                            style: TextStyle(
                                                color: Color(0xFF424283),
                                                fontSize: 16.0,
                                                fontFamily: 'Poppins',
                                              ),
                                          ),
                                    content: Text("Enter info here"),
                                    actions: [
                                        FlatButton(
                                            child: Text("ADD"),
                                            onPressed: () { },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Add experience',
                                style: TextStyle(
                                color: Color(0xFF424283),
                                fontSize: 20.0,
                                fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                              Padding(
                            padding: EdgeInsets.only(left:18.0),
                            child: Text('Showcase your work experience ',
                                  style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  ),
                                ),
                          ),
                              Divider(
                            thickness: 1.0,
                            color: Colors.grey,
                          ),
                            ],
                          ) : SizedBox(),

                        ],
                      ),
                    ),
              ),
                  ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isEducation = !isEducation;
                    });
                  },
                  topicName: 'Education',
                  isVisible: isEducation,
                  dropdownContainer: Container(child: Text('Education'),),
              ),
                  ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isAchivemnets = !isAchivemnets;
                    });
                  },
                  topicName: 'Achievements',
                  isVisible: isAchivemnets,
                  dropdownContainer: Container(child: Text('Achivement'),),
              ),
                  ResumeTopic(
                    key: UniqueKey(),
                  isEditMode: isEditMode,
                  onTapFunction: (){
                    setState(() {
                      isYibe = !isYibe;
                    });
                  },
                  topicName: 'Yibe Stats ',
                  isVisible: isYibe,
                  dropdownContainer: Container(child: Text('Yibe stats'),),
              ),
                ],
                onReorder: (int oldIndex, int newIndex){
                  setState(() {
                    },);
                }),
            ),*/
