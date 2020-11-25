import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:yibe_final_ui/pages/viewOtherUserProfProfile.dart';
import 'package:yibe_final_ui/pages/viewOtherUserPvtProfile.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';



class SearchUsers extends StatefulWidget {
  bool didNavigatedFromPvtAc;
  SearchUsers({this.didNavigatedFromPvtAc});

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  StreamSubscription<QuerySnapshot> _allUsersSubscription;
  List<DocumentSnapshot> _allUserList=[];
  List<DocumentSnapshot> filteredUserList=[];
  static bool isSearching = false;

  @override
  void initState(){
    super.initState();
    print(widget.didNavigatedFromPvtAc);
   widget.didNavigatedFromPvtAc ? _allUsersSubscription = DatabaseService.instance.getAllUsers().listen((dataSnapshot) {
    print(dataSnapshot.docs.length);
      setState(() {
        _allUserList = dataSnapshot.docs;
        for(var i=0; i < _allUserList.length ; i++) {
          print(_allUserList[i].data()['pvtId'] );
          if (_allUserList[i].data()['pvtId'] == UniversalVariables.myPvtUid) {_allUserList.removeAt(i);}
          filteredUserList = _allUserList;
          //print(_allUserList);
         // print(filteredUserList);
        }
      });
    }) : _allUsersSubscription = DatabaseService.instance.getAllProfUsers().listen((dataSnapshot) {
      print(dataSnapshot.docs.length);
     setState(() {
       _allUserList = dataSnapshot.docs;
       for (var i = 0; i <= _allUserList.length; i++) {
         if (_allUserList[i].data()['profId'] == UniversalVariables.myProfUid) {
           _allUserList.removeAt(i);
         }
         filteredUserList = _allUserList;
       }
     });
   });
  }

  @override
  void dispose(){
    _allUsersSubscription.cancel();
    super.dispose();
  }

  void _filteredUserInSearchController(String value) {
    print(value);
    setState(() {
      filteredUserList = _allUserList.where((user) => user.data().containsKey('BusinessName') ? user.data()['BusinessName'].toLowerCase().contains(value.toLowerCase()) : user.data()['fullname'].toLowerCase().contains(value.toLowerCase())).toList() ;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// private search will show both private and professional users
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: !isSearching ? Text('') : TextField(
            onChanged: (value) {_filteredUserInSearchController(value);},
            style: TextStyle(color: white),
            decoration: InputDecoration(
                hintText: 'Search Users here',
                hintStyle: TextStyle(color: white)),
          ),
          actions: <Widget>[
            isSearching ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  filteredUserList = _allUserList;
                });
              },
            )
                : IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            )
          ],
        ),
          body: filteredUserList.length > 0 ? ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, i) {
                return Column(children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (filteredUserList[i].data().containsKey('BusinessName')) {
                           NavigationService.instance.pushTo(
                                MaterialPageRoute(builder: (_) => ViewOtherUserProfProfile(
                                         navigatedFromPrivateAc: widget.didNavigatedFromPvtAc,
                                          otherUserBusinessName: filteredUserList[i].data()['BusinessName'],
                                          otherUserPvtUid: filteredUserList[i].data()['pvtId'],
                                          otherUserProfUid: filteredUserList[i].data()['profId'],
                                          otherUserName: filteredUserList[i].data()['profUserName'],
                                          otherUserProfile: filteredUserList[i].data()['profUrl'],
                                          otherUserBio: filteredUserList[i].data()['BusinessBio'],
                                      ),
                                    ));
                           } else {
                            NavigationService.instance.pushTo(
                                MaterialPageRoute(builder: (_) =>
                                    ViewOtherUserPvtProfile(
                                        otherUserFullName: filteredUserList[i].data()['fullname'],
                                        otherUserUid: filteredUserList[i].data()['pvtId'],
                                        otherUserName: filteredUserList[i].data()['username'],
                                        otherUserProfile: filteredUserList[i].data()['privateUrl']!=null? filteredUserList[i].data()['privateUrl'] : UniversalVariables.defaultImageUrl ,
                                        otherUserBio: filteredUserList[i].data()['pvtBio']!=null ? filteredUserList[i].data()['pvtBio'] : 'Bio is Empty')));
                          }},
                        child: filteredUserList[i].data()['accountType']=='Professional' ? ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: filteredUserList[i].data()['profUrl']!=null ? NetworkImage(filteredUserList[i].data()['profUrl']) : NetworkImage(UniversalVariables.defaultImageUrl),
                            ),
                            title: filteredUserList[i].data()['BusinessName']!=null ? Text(filteredUserList[i].data()['BusinessName']) : Text(filteredUserList[i].data()['fullname']),
                            subtitle: Text(filteredUserList[i].data()['profUserName'], style: TextStyle(color: Colors.grey))
                        ) : ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: filteredUserList[i].data()['privateUrl']!=null ? NetworkImage(filteredUserList[i].data()['privateUrl']) : NetworkImage(UniversalVariables.defaultImageUrl),
                            ),
                            title: filteredUserList[i].data()['fullname']!=null ? Text(filteredUserList[i].data()['fullname'], style: TextStyle(fontWeight: FontWeight.bold)) : Text('No fullname'),
                            subtitle: filteredUserList[i].data()['username']!=null ? Text(filteredUserList[i].data()['username'], style: TextStyle(color: Colors.grey)) : Text('No username')
                        ),
                    ),
                    Divider(
                      height: 10.0,
                    ),
                  ]);
              }) : _allUserList.isEmpty ? Center(child: Container(child: Text('Search users here'))) : Center(child: Container(child: Text('No such user exists!')))
      ),
    );
  }
}
