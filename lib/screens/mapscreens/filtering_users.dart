import 'package:collegesection/screens/mapscreens/FilteringUsersMap.dart';

import 'package:collegesection/services/filteringUsersDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class FilteringUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () async {
              LocationResult loc = await showLocationPicker(
                  context, 'AIzaSyA1xkcTC9aSwxEcKRz4TCBNOqfx0BI_ODY');
              await FilteringUsersDatabaseService()
                  .updateLoc(loc.latLng.latitude, loc.latLng.longitude);
            },
            child: Text('Add Dummy UserLocation'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return FilterMap();
              }));
            },
            child: Text('Map'),
          ),
        ],
      ),
    );
  }
}
