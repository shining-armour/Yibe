import 'package:flutter/material.dart';
import 'package:yibe_final_ui/utils/helper_functions.dart';

class CustomDialog extends StatelessWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryButtonRoute});

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff12ACB1),
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  description,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                  color: Color(0xff12ACB1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      primaryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    print('primary button pressed');
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(primaryButtonRoute);
                    HelperFunction.saveHibernationModeAsSharedPreference(true);
                  },
                ),
                SizedBox(height: 10.0),
                showSecondaryButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return FlatButton(
        child: Text(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff12ACB1),
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          print('secondary button');
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
        },
      );
    } else {
      return SizedBox(height: 10.0);
    }
  }
}
