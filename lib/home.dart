import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/CalendarManager.dart';
import 'package:flutter_app/therapistsCarousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import internal services manager
import 'package:flutter_app/ProvidedServicesGrid.dart';
//import Calendar
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Import clinic model
import 'package:flutter_app/models/clinics_model.dart';

/* import map locations */
import 'src/locations.dart' as locations;

/* TODO MAKE THIS A STATEFUL WIDGET */
class HomePage extends StatelessWidget {
  //For viewing and controlling a calendar
  CalendarController _controller;

  // For icons to toggle the sites on map and choose service
  List<IconData> _icons = [
    FontAwesomeIcons.speakap,
    FontAwesomeIcons.airbnb,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.running,
  ];

  // For Physio Clinics
  // TODO move this to its own class
  // var clinics = ['Kevin', 'Christina', 'Rosanne', 'Sante'];

  /* TODO fix this later.. for now set the current index to 1 */
  int _selectedIndex = 1;

  Widget _buildIcon(int index, BuildContext context) {
    return GestureDetector(
        child: Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Icon(
              _icons[index],
              size: 25.0,
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Color(0xFFB4C1C4),
            )));
  }

  // init tree map
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();

    // setState( () {
    _markers.clear();

    for (final office in googleOffices.offices) {
      final marker = Marker(
        markerId: MarkerId(office.name),
        position: LatLng(office.lat, office.lng),
        infoWindow: InfoWindow(
          title: office.name,
          snippet: office.address,
        ),
      );

      _markers[office.name] = marker;
    }
  }

  /* Get the locations for map async */
  Future<void> _buildCardMap() async {
    final googleOffices = await locations.getGoogleOffices();
  }

  @override
  Widget build(BuildContext context) {
    // /* TODO how can we init stuff in a stateless class ?? */
    // Initialize CalendarController before using
    _controller ??= CalendarController();

    return Scaffold(
        body: SafeArea(
          child: ListView(
              padding: EdgeInsets.all(10.0),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 100.0),
                  child: Text(
                    "Please choose a service near you",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0), // Padding between Text and Map
                // TODO fix the logic of the color of the selected buttons
                ProvidedServicesGrid(),
                TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Where",
                      icon: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xFFEEF8FF),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 25.0,
                            color: Color(0xFF309DF1),
                          ))),
                ),
                Divider(height: 40.0),
                TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Appointment Date",
                      icon: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xFFEEF8FF),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            size: 25.0,
                            color: Color(0xFF309DF1),
                          ))),
                ),
                Divider(height: 40.0),
                SizedBox(
                    width: 100,
                    height: 500,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: const LatLng(
                                43.71889356929494, -79.72247294477522),
                            zoom: 2),
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(() =>
                              PanGestureRecognizer())))), // Sized Box For Map
                SizedBox(height: 10.0), // Padding between map and service icon
                Divider(height: 40.0),
                TherapistsCarousel(),
                SizedBox( height: 10.0, ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      minWidth: 175.0,
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(
                         horizontal: 50.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () {},
                      child: Text( 'Book',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox( width: 10.0, ),
                    FlatButton(
                      minWidth: 175.0,
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {},
                        child: Text( 'Chat',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                        ),
                    ),
                  ],
                ),
                SizedBox( height: 10.0, ),
                CalendarManager(),
              ]),
        ),
        bottomNavigationBar: BottomNavigationBar(currentIndex: 0, items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.local_pizza,
                size: 30.0,
              ),
              title: SizedBox.shrink()),
        ]));
  }
}
