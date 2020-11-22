import 'package:collegesection/Money/MoneyMatters.dart';
import 'package:collegesection/models/user.dart';
import 'package:collegesection/screens/activities/activities_home.dart';
import 'package:collegesection/screens/events/events_home.dart';
import 'package:collegesection/screens/growth/growth_home.dart';
import 'package:collegesection/screens/growth/my_resume.dart';
import 'package:collegesection/screens/mapscreens/Experiment_map.dart';
import 'package:collegesection/screens/mapscreens/Vibe_map.dart';
import 'package:collegesection/screens/mapscreens/filtering_users.dart';
import 'package:collegesection/services/auth.dart';
import 'package:collegesection/services/userdatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String devToken = '';
  UserDetails user;

  void initState() {
    super.initState();
    _updateUser();
  }

  void _updateUser() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await FirebaseMessaging().getToken().then((deviceToken) {
      print('DeviceToken : $deviceToken');
      setState(() {
        devToken = deviceToken;
      });
    });
    print(devToken);
    await UserDatabaseService(uid: user.uid).updateUserDataWithDetails(
        position.latitude, position.longitude, devToken);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "  Hello,",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Text(
            "     Simba",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Events(user.uid)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              // image: new DecorationImage(image: SvgPicture.asset("assets/party.png"),fit: BoxFit.fill),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: SvgPicture.asset(
                            "assets/events.svg",
                            fit: BoxFit.cover,
                          ),
                          // color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ActivityHome(uid: user.uid)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //     image: new DecorationImage(
                          //         image: AssetImage("assets/party.png"),
                          //         fit: BoxFit.fill),
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(20))),
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height / 6,
                          child: SvgPicture.asset(
                            "assets/activities.svg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     image: new DecorationImage(
                            //         image: AssetImage("assets/party.png"),
                            //         fit: BoxFit.fill),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(20))),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height / 6,
                            child: SvgPicture.asset(
                              "assets/growth.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GrowthHome(uid: user.uid)))),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MoneyMatters(user.uid);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          // image: new DecorationImage(
                          //     image: AssetImage("assets/party.png"),
                          //     fit: BoxFit.fill),
                          // borderRadius:
                          //     BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height / 6,
                          child: SvgPicture.asset(
                            "assets/money.svg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "   Hot 'n Happening",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 20),
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.orange.shade400,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[],
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 20),
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 20),
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.shade400,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            "   Vibe with someone",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Map_Vibe()));
            },
            child: Container(
              width: 250,
              margin: EdgeInsets.all(10),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        "Map",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Text(
            "   Everyday Hustle",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Signout'),
                onTap: () async {
                  await AuthService().signOut();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text('My Resume'),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyResume(uid: user.uid)))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Experiment Map'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ExperimentMap();
                  }));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('DummyUsers'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return FilteringUsers();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
