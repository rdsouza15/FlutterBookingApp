import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/clinics_model.dart';

/* A class to manage all the services provided in the app
* ( Physio, Massage, Speech, PSW ) and display them in a Grid
* The selected service should set a state for the caller */
class ProvidedServicesGrid extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ProvidedServicesGridState();
  }
}

class _ProvidedServicesGridState extends State<ProvidedServicesGrid>{

  int _selectedIndex = 0;

  // All services are listed here
  final List<String> servicesList = [
    "Physio",
    "Speech",
    "Massage",
    "PSW",
  ];

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: servicesList.length,
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: ( context, index ) {
          return FlatButton(
            color: _selectedIndex == index ? Colors.orange : Colors.grey,
            padding: EdgeInsets.symmetric(
                horizontal: 40.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: _selectedIndex != index
                    ? Colors.transparent
                    : Colors.black, // TODO fix this with stateful widget
              ),
            ),
            // color: _selectedIndex == 0 ? Color(0xFFFFC05F) : null,
            child: Text(servicesList[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        }
    );
  }
}