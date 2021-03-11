import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
// import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_app/src/locations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class StoreCarousel extends StatelessWidget {
  const StoreCarousel({
    Key key,
    @required this.documents,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: 90,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 340,
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Card(
                      child: Center(
                        child: StoreListTile(
                          document: documents[index],
                          mapController: mapController,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
    return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (builder, index) {
          final document = documents[index];
          return StoreListTile(
            document: document,
            mapController: mapController,
          );
        });
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key key,
    @required this.document,
    @required this.mapController,
  }) : super(key: key);

  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

// TODO abstract api key from here
final _placesApiClient =
    GoogleMapsPlaces(apiKey: 'AIzaSyBwdNESWmEg04tWTIrI3A-SAVuUyze0BB8');

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _retrievePlacesDetails();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _retrievePlacesDetails() async {
    // TODO for now just use the photo of Montana's as the image from placeId
    final details = await _placesApiClient
        .getDetailsByPlaceId('ChIJJYwljWoWK4gRPQxGn4eniA0');
    // await _placesApiClient.getDetailsByPlaceId( widget.document['placeId']);

    if (!_disposed) {
      setState(() {
        _placePhotoUrl = _placesApiClient.buildPhotoUrl(
          photoReference: details.result.photos[0].photoReference,
          maxHeight: 300,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['name']),
      subtitle: Text(widget.document['address']),
      leading: Container(
        child: _placePhotoUrl.isNotEmpty
            ? ClipRRect(
                child: Image.network(_placePhotoUrl, fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(2)))
            : Container(),
        width: 60,
        height: 60,
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(43.732787396886614, -79.76435832095676),
              zoom: 14,
            ),
          ),
        );
      },
    );
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
// Map Controller to update the map when item in list is pressed
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.0,
      child: GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: const LatLng(43.71889356929494, -79.7247294477522),
              zoom: 12),
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
            )
            ..add(
              Factory<HorizontalDragGestureRecognizer>(
                  () => HorizontalDragGestureRecognizer()),
            )
            ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
            ),
          markers: documents
              .map((document) => Marker(
                    markerId: MarkerId(document['name']),
                    icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
                    position: LatLng(43.732787396886614, -79.76435832095676),
                    infoWindow: InfoWindow(
                      title: document['name'],
                      snippet: document['address'],
                    ),
                  ))
              .toSet(),
          onMapCreated: (mapController) {
            this.mapController.complete(mapController);
          }),
    );// Sized Box For Map
  }
}

class MapsManager extends StatefulWidget {
  @override
  MapsManagerState createState() {
    return MapsManagerState();
  }
}

class MapsManagerState extends State<MapsManager> {
  // member accessor for clinic info from database
  Stream _clinicLocations;

  // Google map controller for future tasks
  final Completer<GoogleMapController> _mapController = Completer();

  // Set up initial state
  @override
  void initState() {
    _clinicLocations = FirebaseFirestore.instance
        .collection('Clinic')
        .orderBy('name')
        .snapshots();
  }

  // build out the UI
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _clinicLocations,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }

          // lets try adding this to a map
          return Stack(children: [
            StoreMap(
              documents: snapshot.data.docs,
              initialPosition:
                  const LatLng(43.732787396886614, -79.76435832095676),
              mapController: _mapController,
            ),
            StoreCarousel(
              documents: snapshot.data.docs,
              mapController: _mapController,
            ),
          ]);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.address),
          onTap: () => print(record),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final String address;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['address'] != null),
        name = map['name'],
        address = map['address'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$address>";
}
