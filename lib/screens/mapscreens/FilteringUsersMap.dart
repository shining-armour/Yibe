import 'package:collegesection/models/exp_loc.dart';
import 'package:collegesection/services/filteringUsersDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FilterMap extends StatefulWidget {
  @override
  _FilterMapState createState() => _FilterMapState();
}

class _FilterMapState extends State<FilterMap> {
  Position initPos = Position(latitude: 20.5937, longitude: 78.9629);
  Position curPosition;
  List<Marker> markers = [];
  int noOfEvents;
  int range = 100;
  List<ExpUser> details;
  double sliderVal = 1;

  void initState() {
    super.initState();
    _updateActivityMarkers();
  }

  void _updateActivityMarkers() async {
    Position userLoc = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    details = await FilteringUsersDatabaseService()
        .getMarkers(range, userLoc.latitude, userLoc.longitude);

    List<Marker> list = [];
    for (int i = 0; i < details.length; i++) {
      list.add(Marker(
        anchor: Offset(0.5, 0.5),
        flat: true,
        zIndex: 2,
        draggable: false,
        markerId: MarkerId(i.toString()),
        position: LatLng(details[i].lat, details[i].long),
      ));
    }
    if (this.mounted) {
      this.setState(() {
        markers = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 4,
                target: LatLng(initPos.latitude, initPos.longitude),
              ),
              markers: Set.of(markers),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
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
                    max: 15,
                    divisions: 14,
                    label: '$sliderVal km',
                    onChanged: (value) {
                      setState(
                        () {
                          sliderVal = value;
                          range = value.toInt();
                        },
                      );
                    },
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () async {
                    _updateActivityMarkers();
                  },
                  child: Text('Go'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
