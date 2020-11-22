import 'dart:async';
import 'dart:typed_data';

import 'package:collegesection/models/Activity.dart';
import 'package:collegesection/screens/activities/activity_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:collegesection/services/activity_database.dart';

class ActivityMap extends StatefulWidget {
  final String uid;

  ActivityMap({this.uid});

  @override
  _ActivityMapState createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  Uint8List gps, sport;

  Position initPos = Position(latitude: 20.5937, longitude: 78.9629);
  Position curPosition;
  GoogleMapController _mapController;
  Location locationTracker = Location();
  Marker userLocMarker;
  StreamSubscription _locationSubscription;
  List<Marker> markers = [];
  int noOfEvents;
  List<ActivityDetails> details = [];
  List<Uint8List> markerImg = [];
  LocationData userLoc;
  int range = 100;
  double sliderVal = 1;

  void initState() {
    super.initState();
    _getCurrentLocation();
    _updateActivityMarkers();
  }

  void _getMarkers() async {
    ByteData gpsbyteData =
        await DefaultAssetBundle.of(context).load('assets/gps.png');
    ByteData sportbyteData =
        await DefaultAssetBundle.of(context).load('assets/sports.png');

    gps = gpsbyteData.buffer.asUint8List();
    sport = sportbyteData.buffer.asUint8List();

    markerImg.add(gps);
    markerImg.add(sport);
  }

  void _updateActivityMarkers() async {
    _getMarkers();
    details = range != 100
        ? await ActivityDatabaseService(uid: widget.uid)
            .nearestActivityDetailsForMarkers(
                userLoc.latitude, userLoc.longitude, range)
        : await ActivityDatabaseService(uid: widget.uid)
            .activityDetailsForMarkers();
    List<Marker> list = [];
    for (int i = 0; i < details.length; i++) {
      list.add(Marker(
          anchor: Offset(0.5, 0.5),
          flat: true,
          zIndex: 2,
          draggable: false,
          markerId: MarkerId(i.toString()),
          position: LatLng(details[i].lat, details[i].long),
          icon: BitmapDescriptor.fromBytes(markerImg[1]),
          infoWindow: InfoWindow(
              title: details[i].activityTitle,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ActivityDisplay(uid: widget.uid, a: details[i]);
                }));
              })));
    }
    if (this.mounted) {
      this.setState(() {
        markers = list;
      });
    }
  }

  void _updateMarker(LocationData loc) {
    LatLng latLng = LatLng(loc.latitude, loc.longitude);
    if (this.mounted) {
      this.setState(() {
        userLoc = loc;
        userLocMarker = Marker(
          markerId: MarkerId('myLoc'),
          anchor: Offset(0.5, 0.5),
          flat: true,
          position: latLng,
          zIndex: 2,
          draggable: false,
          infoWindow: InfoWindow(title: 'Your Location'),
          icon: markerImg[0] != null
              ? BitmapDescriptor.fromBytes(markerImg[0])
              : BitmapDescriptor.defaultMarker,
        );
      });
    }
  }

  void _getCurrentLocation() async {
    try {
      var location = await locationTracker.getLocation();
      _updateMarker(location);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription =
          locationTracker.onLocationChanged.listen((newData) {
        if (_mapController != null) {
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: 12,
                  target: LatLng(newData.latitude, newData.longitude))));
          _updateMarker(newData);
        }
      });
    } catch (e) {
      print(e);
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
              markers: Set.of(
                  userLocMarker == null ? markers : markers + [userLocMarker]),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: () {
          _getCurrentLocation();
        },
      ),
    );
  }
}
