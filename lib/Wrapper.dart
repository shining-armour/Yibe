import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yibe_final_ui/model/user.dart';
import 'package:yibe_final_ui/model/acType.dart';
import 'package:yibe_final_ui/auth/LogInPage.dart';
import 'package:yibe_final_ui/pages/PageHandler.dart';
import 'package:yibe_final_ui/utils/helper_functions.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/pages/Hybernation.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  static bool isHibernation;

  @override
  void initState(){
    super.initState();
    getUserInfoFromSP();
    getHibernationMode();
  }

  void getHibernationMode() async{
    await HelperFunction.getHibernationModeSharedPreference().then((value) => setState((){
      if (value==true){
       isHibernation = value;
        NavigationService.instance.pushReplacementNamedTo('hybernation');
      } else{
        isHibernation = false;
      }
    }));
  }

  Future<void> getUserInfoFromSP() {
    HelperFunction.getUserPvtUidSharedPreference().then((value) => setState(() {
      UniversalVariables.myPvtUid = value;
      print('User Id : '+ UniversalVariables.myPvtUid + ' in pvt home page');
    }));
    HelperFunction.getUserNameSharedPreference().then((value) => setState(() {
      UniversalVariables.myPvtUsername = value;
      print('username : '+ UniversalVariables.myPvtUsername +' in pvt home page');
    }));
    HelperFunction.getUserEmailIdSharedPreference().then((value) => setState(() {
      UniversalVariables.myEmail = value;
      print('emailId : '+ UniversalVariables.myEmail + ' in pvt home page');
    }));
    HelperFunction.getFullNameSharedPreference().then((value) => setState(() {
      UniversalVariables.myPvtFullName = value;
      print('Fullname : '+ UniversalVariables.myPvtFullName + ' in pvt home page');
    }));
    HelperFunction.getUserProfUidSharedPreference().then((value) =>
        setState(() {
          UniversalVariables.myProfUid = value;
          print('prof uid : '+ UniversalVariables.myProfUid + ' in pvt home page');
        }));
  }

  @override
  Widget build(BuildContext context) {
    UserDetails user = Provider.of<UserDetails>(context);

    if (user == null) {
      return LogInPage();
    } else {
      if(isHibernation){
        return Hybernation();
      } else{
        return PageHandler();
      }
    }
  }
}
