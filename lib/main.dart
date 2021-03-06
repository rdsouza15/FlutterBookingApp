// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* import map locations */
import 'src/locations.dart' as locations;

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
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
/* A Widget for displaying RandomWords */
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

/* The controller for the RandomWords view */
class _RandomWordsState extends State<RandomWords> {

  // ListView
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  /* Function to build word suggestions */
  Widget _buildSuggestions(){
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if( i.isOdd ) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/

          if( index >= _suggestions.length ){
            _suggestions.addAll( generateWordPairs().take( 10 ) );
          }

          return _buildRow( _suggestions[index] );
        },
    );
  }

  /* Function to build out a row */
  Widget _buildRow( WordPair pair ){
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
