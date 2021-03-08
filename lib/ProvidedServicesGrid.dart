import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/clinics_model.dart';

// Initial selected index .. this will set the selected state for the rest of the app
// TODO use cleaner way to get and set this value
int _selectedIndex = 0;

/* A class to manage all the services provided in the app
* ( Physio, Massage, Speech, PSW ) and display them in a Grid
* The selected service should set a state for the caller */
class ProvidedServicesGrid extends StatelessWidget{

  @override
  Widget build( BuildContext context ){

    return Container(
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
        ),
    );
  }
}