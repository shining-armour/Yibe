import 'dart:io';

import 'package:collegesection/models/event.dart';
import 'package:collegesection/models/user.dart';
import 'package:collegesection/services/eventdatabase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';

class AddEvent extends StatefulWidget {
  final String uid;

  AddEvent(this.uid);

  @override
  _AddEventState createState() => _AddEventState();
}

enum EventType { college, music, party }

class _AddEventState extends State<AddEvent> {
  String eName = '',
      address = '',
      description = '',
      eligibility = '',
      otherDetails = '',
      pickedTime = '',
      pickedPlace = '',
      url = '',
      _uploadFileName = '',
      eventType = 'college';

  EventType type = EventType.college;
  File _imageFile;
  LocationResult result;

  DateTime pickedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  void _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  void _pickTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null)
      setState(() {
        pickedTime = t.hour.toString() + ':' + t.minute.toString();
      });
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    print('success');
  }

  Future<void> _pickImage() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = selected;
      _uploadFileName = 'images/${DateTime.now()}.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Event Name',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Event Name' : null,
                  onChanged: (val) {
                    setState(() => eName = val);
                  },
                ),
              ),
              new Text(
                'Type of event:',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: EventType.college,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        eventType = 'College';
                        type = value;
                      });
                    },
                  ),
                  Text(
                    'College Fest',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: EventType.music,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        eventType = 'Music';
                        type = value;
                      });
                    },
                  ),
                  Text(
                    'Music Fest',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Radio(
                    value: EventType.party,
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        eventType = 'Party';
                        type = value;
                      });
                    },
                  ),
                  Text(
                    'Party',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Address' : null,
                  onChanged: (val) {
                    setState(() => address = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Description' : null,
                  onChanged: (val) {
                    setState(() => description = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Eligibility',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Eligibility' : null,
                  onChanged: (val) {
                    setState(() => eligibility = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Other Details',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Other Details' : null,
                  onChanged: (val) {
                    setState(() => otherDetails = val);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ListTile(
                subtitle: Text('Date of event'),
                title: Text(pickedDate.day.toString() +
                    '/' +
                    pickedDate.month.toString() +
                    '/' +
                    pickedDate.year.toString()),
                trailing: FlatButton.icon(
                  label: Text(''),
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _pickDate();
                  },
                ),
              ),
              ListTile(
                subtitle: Text('Time of event'),
                title: pickedTime == ''
                    ? Text(DateTime.now().hour.toString() +
                        ':' +
                        pickedDate.minute.toString())
                    : Text(pickedTime),
                trailing: FlatButton.icon(
                  label: Text(''),
                  icon: Icon(Icons.lock_clock),
                  onPressed: () {
                    _pickTime();
                  },
                ),
              ),
              ListTile(
                title: Text(''),
                subtitle: Text('Location of Event'),
                trailing: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () async {
                    LocationResult loc = await showLocationPicker(
                        context, 'AIzaSyA1xkcTC9aSwxEcKRz4TCBNOqfx0BI_ODY');
                    setState(() {
                      result = loc;
                      pickedPlace = loc.latLng.latitude.toString() +
                          ',' +
                          loc.latLng.longitude.toString();
                    });
                  },
                ),
              ),
              RaisedButton.icon(
                onPressed: () async {
                  await _pickImage();
                },
                icon: Icon(Icons.photo),
                label: Text('Event Poster'),
              ),
              _imageFile != null
                  ? Container(
                      color: Colors.grey[200],
                      height: 300.0,
                      child: Image.file(_imageFile))
                  : Container(
                      color: Colors.grey[200],
                      height: 150.0,
                      child: Center(
                          child: Text(
                        'Click the above Button to choose image!',
                        style: TextStyle(color: Colors.black),
                      )),
                    ),
              RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print('hi');
                    await _uploadFile(_imageFile, _uploadFileName);

                    EventDetails e = EventDetails(
                        eventName: eName,
                        address: address,
                        description: description,
                        eligibility: eligibility,
                        otherDetails: otherDetails,
                        timeOfEvent: pickedTime,
                        lat: result.latLng.latitude,
                        long: result.latLng.longitude,
                        posterUrl: url,
                        eventType: eventType,
                        dateOfEvent: pickedDate.day.toString() +
                            '/' +
                            pickedDate.month.toString() +
                            '/' +
                            pickedDate.year.toString());
                    print(e);
                    await EventDatabaseService(uid: widget.uid)
                        .updateEventData(e);
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                    content: Text('Saved Successfully'),
//                    duration: Duration(seconds: 3),
//                  ));
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
