import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'schedule_model.dart';
import 'dart:math' as math;

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.workWeek,
      dataSource: MeetingDataSource(_getDataSource()),
      timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 6, endHour: 18, nonWorkingDays: <int>[DateTime.sunday]),
    ));
  }
  /*
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.schedule,
        dataSource: MeetingDataSource(_getDataSource()),
        scheduleViewSettings: const ScheduleViewSettings(
            monthHeaderSettings: MonthHeaderSettings(
                monthFormat: 'MMMM, yyyy',
                height: 100,
                textAlign: TextAlign.left,
                backgroundColor: Colors.green,
                monthTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.w400))),
      ),
    );
  }
  */

  /*

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.schedule,
        dataSource: MeetingDataSource(_getDataSource()),
        scheduleViewSettings: const ScheduleViewSettings(
            appointmentTextStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.lime)),
      ),
    );
  }

  */

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(_getDataSource()),
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    ));
  }
  */

  List<Scheduler> lst = [
    Scheduler(
        division: "6746QQ1",
        task: "Irrigation",
        commencement: DateTime(2025, 01, 13, 6),
        duration: const Duration(minutes: 120)),
    Scheduler(
        division: "6746QQ1",
        task: "Farm Levelling",
        commencement: DateTime(2025, 01, 13, 8),
        duration: const Duration(minutes: 240)),
    Scheduler(
        division: "6746QQ1",
        task: "Manure Sourcing",
        commencement: DateTime(2025, 01, 13, 12),
        duration: const Duration(minutes: 120)),
    Scheduler(
        division: "6746QQ1",
        task: "Farm Gamma Clearing",
        commencement: DateTime(2025, 01, 14, 6),
        duration: const Duration(minutes: 360)),
    Scheduler(
        division: "6746QQ1",
        task: "Nursery Seedling",
        commencement: DateTime(2025, 01, 14, 12),
        duration: const Duration(minutes: 120)),
    Scheduler(
        division: "6746QQ1",
        task: "Bamboo Cutting",
        commencement: DateTime(2025, 01, 15, 6),
        duration: const Duration(minutes: 360)),
    Scheduler(
        division: "6746QQ1",
        task: "Beans Separation",
        commencement: DateTime(2025, 01, 15, 12, 20),
        duration: const Duration(minutes: 100)),
    Scheduler(
        division: "6746QQ1",
        task: "Beans Planting  & Transplanting",
        commencement: DateTime(2025, 01, 16, 6),
        duration: const Duration(minutes: 480)),
    Scheduler(
        division: "6746QQ1",
        task: "Pen Construction",
        commencement: DateTime(2025, 01, 17, 6),
        duration: const Duration(minutes: 480)),
    Scheduler(
        division: "6746QQ1",
        task: "Pen Construction",
        commencement: DateTime(2025, 01, 18, 6),
        duration: const Duration(minutes: 360)),
    Scheduler(
        division: "6746QQ1",
        task: "Irrigation",
        commencement: DateTime(2025, 01, 20, 6),
        duration: const Duration(minutes: 120)),
    Scheduler(
        division: "6746QQ1",
        task: "Transplanting",
        commencement: DateTime(2025, 01, 20, 8),
        duration: const Duration(minutes: 120)),
    Scheduler(
        division: "6746QQ1",
        task: "NPK Side Placing",
        commencement: DateTime(2025, 01, 20, 10),
        duration: const Duration(minutes: 240)),
  ];

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (Scheduler item in lst) {
      meetings.add(Meeting(
          item.task,
          item.commencement,
          item.commencement.add(item.duration),
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          false));
    }
    /*
    final DateTime today = DateTime.now();
    //
    final DateTime startTime_Mon_1 = DateTime(2025, 01, 13, 6);
    final DateTime endTime_Mon_1 =
        startTime_Mon_1.add(const Duration(minutes: 120));

    final DateTime startTime_Mon_2 = DateTime(2025, 01, 13, 8);
    final DateTime endTime_Mon_2 =
        startTime_Mon_1.add(const Duration(minutes: 120));

    meetings.add(Meeting('Irrigation', startTime_Mon_1, endTime_Mon_1,
        Color.fromARGB(255, 159, 221, 188), false));

    final DateTime startTime_Tue = DateTime(2025, 01, 14, 10);
    final DateTime endTime_Tue =
        startTime_Tue.add(const Duration(minutes: 145));

    meetings.add(Meeting('NPK Side Placing', startTime_Tue, endTime_Tue,
        Color.fromARGB(255, 223, 154, 214), false));
        */
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
