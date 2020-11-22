import 'package:collegesection/models/Activity.dart';
import 'package:collegesection/services/activity_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class AddActivity extends StatefulWidget {
  final String uid;

  AddActivity({this.uid});

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  List<String> activityTypes = ['Sport', 'ESport', 'Skill'];

  int radioVal = 0, formErr = 0;
  double sliderVal = 1;
  String pickedPlace = '';
  LocationResult result;
  TextEditingController titleCntrl = TextEditingController();
  TextEditingController desCntrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  onChanged: (value) {
                    setState(() {
                      radioVal = value;
                    });
                  },
                  value: 0,
                  groupValue: radioVal,
                ),
                Text('Sport'),
                Radio(
                  onChanged: (value) {
                    setState(() {
                      radioVal = value;
                    });
                  },
                  value: 1,
                  groupValue: radioVal,
                ),
                Text('E-Sport'),
                Radio(
                  onChanged: (value) {
                    setState(() {
                      radioVal = value;
                    });
                  },
                  value: 2,
                  groupValue: radioVal,
                ),
                Text('Skills+'),
              ],
            ),
            TextField(
              controller: titleCntrl,
              decoration: InputDecoration(
                hintText: 'Title',
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
            TextField(
              controller: desCntrl,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Description',
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
            radioVal != 2
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('No of participants:'),
                  )
                : Container(),
            radioVal != 2
                ? SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: sliderVal,
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: '$sliderVal',
                      onChanged: (value) {
                        setState(
                          () {
                            sliderVal = value;
                          },
                        );
                      },
                    ),
                  )
                : Container(),
            radioVal == 0
                ? ListTile(
                    title: Text(pickedPlace),
                    subtitle: Text('Location of Event'),
                    trailing: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () async {
                        LocationResult loc = await showLocationPicker(
                            context, 'AIzaSyA1xkcTC9aSwxEcKRz4TCBNOqfx0BI_ODY');
                        setState(() {
                          result = loc;
                          pickedPlace = result.latLng.latitude.toString() +
                              ',' +
                              result.latLng.longitude.toString();
                        });
                      },
                    ),
                  )
                : Container(),
            RaisedButton(
              onPressed: () async {
                if (titleCntrl.text != '' && desCntrl.text != '') {
                  ActivityDetails details = ActivityDetails(
                      activityTitle: titleCntrl.text,
                      description: desCntrl.text,
                      activityType: activityTypes[radioVal],
                      noOfPlayers: sliderVal.toInt(),
                      lat: result.latLng.latitude,
                      long: result.latLng.longitude,
                      organiserID: widget.uid);
                  await ActivityDatabaseService(uid: widget.uid)
                      .updateActivityData(details);
                  setState(() {
                    titleCntrl.text = '';
                    desCntrl.text = '';
                    sliderVal = 1.0;
                    pickedPlace = '';
                  });
                } else {
                  setState(() {
                    formErr = 1;
                  });
                }
              },
              child: Text('Save'),
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
