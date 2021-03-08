// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* import map locations */
import 'src/locations.dart' as locations;

/* import HomePage */
import 'home.dart';

/* Main entry point into app */
void main() => runApp(MyApp());

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start up Name Generator',
      // home: RandomWords(),
      home: Maps()
    );
  }
}*/

/* this app is a stateful widget ( mutable ) */
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// This is the controller for the Main app view
class _MyAppState extends State<MyApp> {

  // init tree map
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated( GoogleMapController controller ) async {
    final googleOffices = await locations.getGoogleOffices();

    setState( () {
      _markers.clear();

      for( final office in googleOffices.offices ){
        final marker = Marker(
          markerId: MarkerId( office.name ),
          position: LatLng( office.lat, office.lng ),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );

        _markers[office.name] = marker;

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(
            primaryColor: Color( 0xFF3EBACE ),
            accentColor: Color( 0xFFFFC05F ),
            scaffoldBackgroundColor: Color( 0xFFF3F5F7 )
          ),
      home: HomePage(),


    );
  }
}
