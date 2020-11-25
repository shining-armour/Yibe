import 'package:flutter/material.dart';
import 'package:yibe_final_ui/pages/PageHandler.dart';
import 'package:yibe_final_ui/services/auth_service.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/services/snack_bar_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';


class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'sign-in-form');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _snackBarText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            body: Center(
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.fromLTRB(16.0, 70.0, 0.0, 0.0),child:Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontSize: 70.0, fontWeight: FontWeight.bold),
                                ),),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                                  child: Text(
                                    '.',
                                    style: TextStyle(
                                      fontSize: 80.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff12ACB1),),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'email cannot be empty';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'password cannot be empty';
                              }
                              return null;
                            },
                          ),

                          Spacer(),

                          InkWell(
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Color(0xff12ACB1),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text('Log In',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            onTap:() async {
                              if (_formKey.currentState.validate()) {
                                _snackBarText =
                                await AuthenticationService.instance.signIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                print(_snackBarText);
                                if (_snackBarText == 'Sign In Successful') {
                                  SnackBarService.instance.showSnackBar(scaffoldKey, _snackBarText);
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (_) => PageHandler()),
                                      ModalRoute.withName('/pageHandler'));
                                }
                                else{
                                  SnackBarService.instance.showSnackBar(scaffoldKey, _snackBarText);
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20,),

                          InkWell(
                            onTap: ()=>NavigationService.instance.goBack(),
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text('Go Back',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
            )
        )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}