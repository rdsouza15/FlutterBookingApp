import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/* import map locations */
import 'src/locations.dart' as locations;

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

  /* TODO fix this later.. for now set the current index to 1 */
  int _selectedIndex = 1;

  Widget _buildIcon( int index, BuildContext context ){
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
        )
      )
    );
  }

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

    // /* TODO how can we init stuff in a stateless class ?? */
    // Initialize CalendarController before using
    _controller = CalendarController();

    return Scaffold(
        body: SafeArea(
          child: ListView(
            // physics: const AlwaysScrollableScrollPhysics(),
            // crossAxisCount: 1,
            padding: EdgeInsets.all(10.0),
            // childAspectRatio: 8.0 / 9.0,
            children: [
              Padding(
                padding: EdgeInsets.only( left: 20.0, right: 100.0 ),
                child: Text(
                  "Please choose a service near you",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox( height: 20.0 ), // Padding between Text and Map
              SizedBox(
                width: 100,
                height: 500,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng( 43.71889356929494, -79.72247294477522 ),
                    zoom: 2),
                  gestureRecognizers: Set()
                      ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer() ) )
                )
              ), // Sized Box For Map
              SizedBox( height: 10.0 ), // Padding between map and service icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _icons.asMap().entries.map((MapEntry map) => _buildIcon(map.key, context) ).toList(),
              ),
              SizedBox( height: 10.0 ), // Padding between map and service icon
              TableCalendar(
                  initialCalendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                      todayColor: Colors.blue,
                      selectedColor: Theme.of(context).primaryColor,
                      todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.white
                      )
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonTextStyle: TextStyle( color: Colors.white ),
                    formatButtonShowsNext: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,

                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events ) => Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0) ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle( color: Colors.white ),
                      ),
                      ),
                    todayDayBuilder: (context,date,events) => Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Colors.white ),
                      )
                    )
                  ),
                calendarController: _controller,
              )
            ] ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size:30.0,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_pizza,
                  size: 30.0,
                ),
            title: SizedBox.shrink()
            ),
          ]
    )
    );
  }
}
