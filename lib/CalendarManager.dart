import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/clinics_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO remove not used
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

// TODO remove not used
class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

/**
 * Create a list of Appointments
 *  @return _DataSource
 */
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

/* TODO impl logic to hide the appointments from other users and show only a greyed out box
*
*  Function to sets the Data for the Calendar
* */
_DataSource getCalendarDataSource() {

  final List<Appointment> appointments = <Appointment>[];

  appointments.add(Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    subject: 'Ryans Special Meeting',
    color: Color(0xFFfb21f66),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: -2, hours: 4)),
    endTime: DateTime.now().add(Duration(days: -2, hours: 5)),
    subject: 'Development Meeting   New York, U.S.A',
    color: Color(0xFFf527318),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: -2, hours: 3)),
    endTime: DateTime.now().add(Duration(days: -2, hours: 4)),
    subject: 'Project Plan Meeting   Kuala Lumpur, Malaysia',
    color: Color(0xFFfb21f66),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: -2, hours: 2)),
    endTime: DateTime.now().add(Duration(days: -2, hours: 3)),
    subject: 'Support - Web Meeting   Dubai, UAE',
    color: Color(0xFFf3282b8),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(Duration(days: -2, hours: 1)),
    endTime: DateTime.now().add(Duration(days: -2, hours: 2)),
    subject: 'Project Release Meeting   Istanbul, Turkey',
    color: Color(0xFFf2a7886),
  ));

  appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4, days: -1)),
      endTime: DateTime.now().add(const Duration(hours: 5, days: -1)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
      isAllDay: true));

  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 2, days: -4)),
    endTime: DateTime.now().add(const Duration(hours: 4, days: -4)),
    subject: 'Performance check',
    color: Colors.amber,
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 11, days: -2)),
    endTime: DateTime.now().add(const Duration(hours: 12, days: -2)),
    subject: 'Customer Meeting   Tokyo, Japan',
    color: Color(0xFFffb8d62),
  ));

  appointments.add(Appointment(
    startTime: DateTime.now().add(const Duration(hours: 6, days: 2)),
    endTime: DateTime.now().add(const Duration(hours: 7, days: 2)),
    subject: 'Retrospective',
    color: Colors.purple,
  ));

  return _DataSource(appointments);
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

class CalendarManager extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Container( // For Calendar
      height: 500.0,
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: getCalendarDataSource(),
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 9,
          endHour: 16,
        ),
        monthViewSettings: MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            agendaViewHeight: 200
        ),
      ),
    ); // Container for Calendar
  }
}