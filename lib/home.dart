import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* import map locations */
import 'src/locations.dart' as locations;

class HomePage extends StatelessWidget {

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
          (int index) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.asset('assets/diamond.png'),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Title'),
                  SizedBox(height: 8.0),
                  Text('Secondary Text'),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return cards;
  }


  // init tree map
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated( GoogleMapController controller ) async {
    final googleOffices = await locations.getGoogleOffices();

    // setState( () {
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
    }

  /* Get the locations for map async */
  Future<void>_buildCardMap() async {
    final googleOffices = await locations.getGoogleOffices();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            // crossAxisCount: 1,
            padding: EdgeInsets.all(0.0),
            // childAspectRatio: 8.0 / 9.0,
            children: [
              SizedBox(
                width: 100,
                height: 500,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(0, 0),
                    zoom: 2),
                  gestureRecognizers: Set()
                      ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer() ) )
                )
              )
            ] ),
    );
            // children: _buildGridCards(10)));
  }
    //   children: <Widget>[
    //     Card(
    //       clipBehavior: Clip.antiAlias,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           AspectRatio(
    //             aspectRatio: 18.0 / 11.0,
    //             child: Image.asset('assets/diamond.png'),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text('Title'),
    //                 SizedBox(height: 8.0),
    //                 Text('Secondary Text'),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // ));
}
