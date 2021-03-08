import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import Calendar
import 'package:syncfusion_flutter_calendar/calendar.dart';


// Import clinic model
import 'package:flutter_app/models/clinics_model.dart';

/* import map locations */
import 'src/locations.dart' as locations;

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

/* Create a Data Source to get Meetings from */
List<Meeting> _getDataSource() {
  List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(
      Meeting( 'Conference', startTime, endTime, const Color(0xFF0F8644), false)
  );
  return meetings;
}

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
              // physics: const AlwaysScrollableScrollPhysics(),
              // crossAxisCount: 1,
              padding: EdgeInsets.all(10.0),
              // childAspectRatio: 8.0 / 9.0,
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
                Container(
                    height: 180.0,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      padding: const EdgeInsets.all(10.0),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.transparent
                                  : Color(
                                      0xFFFFC05F), // TODO fix this with stateful widget
                            ),
                          ),
                          // color: _selectedIndex == 0 ? Color(0xFFFFC05F) : null,
                          child: Text("Physio",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              )),
                          onPressed: () {
                            _selectedIndex = 0;
                          },
                        ),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 20.0),
                          color: Color(0xFFFFC05F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.transparent
                                  : Color(
                                      0xFFFFC05F), // TODO fix this with stateful widget
                            ),
                          ),
                          // color: _selectedIndex == 0 ? Color(0xFFFFC05F) : null,
                          child: Text("Speech",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              )),
                          onPressed: () {
                            _selectedIndex = 0;
                          },
                        ),
                        FlatButton(
                          color: Color(0xFFFFC05F),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.transparent
                                  : Color(
                                      0xFFFFC05F), // TODO fix this with stateful widget
                            ),
                          ),
                          // color: _selectedIndex == 0 ? Color(0xFFFFC05F) : null,
                          child: Text("Massage",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              )),
                          onPressed: () {
                            _selectedIndex = 0;
                          },
                        ),
                        FlatButton(
                          color: Color(0xFFFFC05F),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: _selectedIndex == 1
                                  ? Colors.transparent
                                  : Color(
                                      0xFFFFC05F), // TODO fix this with stateful widget
                            ),
                          ),
                          // color: _selectedIndex == 0 ? Color(0xFFFFC05F) : null,
                          child: Text("PSW",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              )),
                          onPressed: () {
                            _selectedIndex = 0;
                          },
                        ),
                      ],
                    )),
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
                Container(
                    height: 300.0,
                    // color: Colors.white10,
                    decoration: BoxDecoration(
                      border: Border.all( color: Colors.orangeAccent ),
                      borderRadius: BorderRadius.all( Radius.circular(5.0) )
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clinics.length,
                      itemBuilder: (BuildContext context, int index) {
                        // get instance of a Clinic at the index
                        Clinic clinic = clinics[index];

                        // return the clinic info to screen
                        return Container(
                            margin: EdgeInsets.all(10.0),
                            width: 210.0,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Positioned(
                                    bottom: 15.0,
                                    child: Container(
                                      height: 120.0,
                                      width: 200.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                clinic.person,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                              Text(
                                                clinic.description,
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    )),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0)
                                    ],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image(
                                            height: 180.0,
                                            width: 180.0,
                                            image: AssetImage(clinic.imageUrl),
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                        left: 10.0,
                                        bottom: 10.0,
                                        child: Column(children: <Widget>[
                                          Text(
                                            clinic.city,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.locationArrow,
                                                size: 10.0,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(clinic.country,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.2,
                                                  )),
                                            ],
                                          )
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                    )),
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
                SfCalendar(
                  view: CalendarView.week,
                  dataSource: MeetingDataSource( _getDataSource() ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment ),
                  ),
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
