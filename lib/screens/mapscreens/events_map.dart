import 'dart:async';
import 'dart:typed_data';

import 'package:collegesection/models/event.dart';
import 'package:collegesection/screens/events/event_display.dart';
import 'package:collegesection/services/eventdatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EventsMap extends StatefulWidget {
  final String uid;

  EventsMap(this.uid);

  @override
  _EventsMapState createState() => _EventsMapState();
}

class _EventsMapState extends State<EventsMap> {
  Uint8List gps, clg, party, music;

  Position initPos = Position(latitude: 20.5937, longitude: 78.9629);
  Position curPosition;
  GoogleMapController _mapController;
  Location locationTracker = Location();
  Marker userLocMarker;
  StreamSubscription _locationSubscription;
  List<Marker> markers = [];
  int noOfEvents;
  List<EventDetails> details = [];
  List<Uint8List> markerImg = [];

  void initState() {
    super.initState();
    _updateEventMarkers();
  }

  void _getMarkers() async {
    ByteData gpsbyteData =
        await DefaultAssetBundle.of(context).load('assets/gps.png');
    ByteData collegebyteData =
        await DefaultAssetBundle.of(context).load('assets/college.png');
    ByteData musicbyteData =
        await DefaultAssetBundle.of(context).load('assets/music.png');
    ByteData partybyteData =
        await DefaultAssetBundle.of(context).load('assets/party.png');
    gps = gpsbyteData.buffer.asUint8List();
    clg = collegebyteData.buffer.asUint8List();
    music = musicbyteData.buffer.asUint8List();
    party = partybyteData.buffer.asUint8List();
    markerImg.add(gps);
    markerImg.add(clg);
    markerImg.add(music);
    markerImg.add(party);
  }

  void _updateEventMarkers() async {
    _getMarkers();
    details =
        await EventDatabaseService(uid: widget.uid).eventDetailsForMarkers();
    List<Marker> list = [];
    for (int i = 0; i < details.length; i++) {
      int x = details[i].eventType == 'college'
          ? 1
          : details[i].eventType == 'Music'
              ? 2
              : 3;
      list.add(Marker(
          anchor: Offset(0.5, 0.5),
          flat: true,
          zIndex: 2,
          draggable: false,
          markerId: MarkerId(i.toString()),
          position: LatLng(details[i].lat, details[i].long),
          icon: BitmapDescriptor.fromBytes(markerImg[x]),
          infoWindow: InfoWindow(
              title: details[i].eventName,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return EventDisplay(uid: widget.uid, eid: details[i].eid);
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
        if (markers == []) {
          markers.add(userLocMarker);
        } else {
          markers
              .removeWhere((element) => element.markerId == MarkerId('myLoc'));
          markers.add(userLocMarker);
        }
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
                  zoom: 15,
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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 4,
          target: LatLng(initPos.latitude, initPos.longitude),
        ),
        markers: Set.of(userLocMarker == null ? markers : markers),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
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
