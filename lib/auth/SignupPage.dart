import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/auth_service.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/services/snack_bar_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';



class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'sign-up-form');
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _snackBarText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(16.0, 70.0, 0.0, 0.0),child:Text(
                            'Sign Up',
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
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                          labelText: 'Full Name'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'full-name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                          labelText: 'Username'),
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return 'username cannot be empty';
                        } //TODO: Show error if username contains spaces    //TODO: Check uniqueness of username
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'email cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'password cannot be empty';
                        }
                        return null;
                      },
                      obscureText: true,
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
                          child: Text('Sign Up',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          await AuthenticationService.instance.signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            fullName: _fullNameController.text,
                            userName: _userNameController.text,
                          ).then((value) => setState((){
                            _snackBarText = value;
                          }));
                          if (_snackBarText == 'Sign up successful. Verify your email address to sign in') {
                            SnackBarService.instance.showSnackBar(scaffoldKey, _snackBarText);
                            await NavigationService.instance.pushReplacementNamedTo('logIn');
                          }
                          else{
                            SnackBarService.instance.showSnackBar(scaffoldKey, _snackBarText);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    InkWell(
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
                      onTap: ()=>NavigationService.instance.goBack(),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

}
