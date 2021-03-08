import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/clinics_model.dart';

/* Class to manage the display the of the therapists within a certain region
 * given that the therapy type has been chosen */
class TherapistsCarousel extends StatelessWidget {

  @override
  Widget build( BuildContext context ){

    return Container(
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
        ));
  }
}