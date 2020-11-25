import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yibe_final_ui/auth/NewUser.dart';
import 'package:yibe_final_ui/services/auth_service.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/acType.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool haveProfAc = false;

  @override
  void initState(){
    super.initState();
    DatabaseService.instance.getProfAcStatus().then((value) => setState((){
     haveProfAc = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                    /*  Consumer<AcType>(
                        builder: (context, model, child) =>*/
                            ListTile(
                          title: Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: (){
                            AuthenticationService.instance.signOut();
                           // model.changeAcType();
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (_) => FirstView()),
                                ModalRoute.withName('/firstView'));
                          },
                        ),
                     // ),
                      !haveProfAc ? ListTile(
                        title: Text('Create Professional Account', style: TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () =>NavigationService.instance.pushNamedTo('setUpProfAc'),
                      ): Container(),
                      Divider(
                        height: 10.0,
                      ),
                    ],
                  );
                },
              ),
            ),
      ]),
    );
  }
}

