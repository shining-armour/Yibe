import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Share extends StatelessWidget {
  const Share({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        actions: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/back_btn.svg',
                    // width: 31.0,
                    height: 16.0,
                  ),
                ),
                Spacer(),
                // GestureDetector(
                //   // onLongPress: () {
                //   //   widget.hiberPopUp(true);
                //   // },
                //   onTap: () {
                //     // Navigator.push(context, MaterialPageRoute(builder: (context){
                //     //   return Messages();
                //     // }));
                //   },
                //   child: SizedBox(
                //     height: 30,
                //     width: 30,
                //     child: Icon(
                //       Icons.menu,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}