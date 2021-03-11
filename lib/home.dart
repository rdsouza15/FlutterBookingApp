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

//firebaes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/* import map locations */
import 'src/locations.dart' as locations;
import 'package:flutter_app/MapsManager.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  //For viewing and controlling a calendar
  CalendarController _controller;

  @override
  Widget build(BuildContext context) {

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
                // TODO get selected service and update this class
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
                MapsManager(),
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
                    // TODO when pressed open a chat screen (lots of things to consider here blyat!)
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
                Divider(height: 40.0),
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