import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../global_handlers.dart';
import 'pages/home_page.dart';
import 'schedule_model.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

import 'package:calendar_view/calendar_view.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

DateTime get _now => DateTime.now();

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController()..addAll(_events),
      child: MaterialApp(
        title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        home: const HomePage(),
      ),
    );

    /*

    return MaterialApp(
        title: 'Flutter Week View Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => inScaffold(body: _FlutterWeekViewDemoAppBody()),
          '/day-view': (context) => inScaffold(
                title: 'Demo day view',
                body: _DemoDayView(),
              ),
          '/week-view': (context) => inScaffold(
                title: 'Demo week view',
                body: _DemoWeekView(),
              ),
          '/dynamic-day-view': (context) => _DynamicDayView(),
        },
      );

      */
  }

  static Widget inScaffold({
    String title = 'Flutter Week View',
    required Widget body,
  }) =>
      Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: body,
      );

  List<CalendarEventData> _events = [
    CalendarEventData(
      date: _now,
      title: "Project meeting",
      description: "Today is project meeting.",
      startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
      endTime: DateTime(_now.year, _now.month, _now.day, 22),
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 3)),
      recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
        startDate: _now.subtract(Duration(days: 3)),
      ),
      title: 'Leetcode Contest',
      description: 'Give leetcode contest',
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 3)),
      recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(
        startDate: _now.subtract(Duration(days: 3)),
        frequency: RepeatFrequency.daily,
        recurrenceEndOn: RecurrenceEnd.after,
        occurrences: 5,
      ),
      title: 'Physics test prep',
      description: 'Prepare for physics test',
    ),
    CalendarEventData(
      date: _now.add(Duration(days: 1)),
      startTime: DateTime(_now.year, _now.month, _now.day, 18),
      endTime: DateTime(_now.year, _now.month, _now.day, 19),
      recurrenceSettings: RecurrenceSettings(
        startDate: _now,
        endDate: _now.add(Duration(days: 5)),
        frequency: RepeatFrequency.daily,
        recurrenceEndOn: RecurrenceEnd.after,
        occurrences: 5,
      ),
      title: "Wedding anniversary",
      description: "Attend uncle's wedding anniversary.",
    ),
    CalendarEventData(
      date: _now,
      startTime: DateTime(_now.year, _now.month, _now.day, 14),
      endTime: DateTime(_now.year, _now.month, _now.day, 17),
      title: "Football Tournament",
      description: "Go to football tournament.",
    ),
    CalendarEventData(
      date: _now.add(Duration(days: 3)),
      startTime: DateTime(
          _now.add(Duration(days: 3)).year,
          _now.add(Duration(days: 3)).month,
          _now.add(Duration(days: 3)).day,
          10),
      endTime: DateTime(
          _now.add(Duration(days: 3)).year,
          _now.add(Duration(days: 3)).month,
          _now.add(Duration(days: 3)).day,
          14),
      title: "Sprint Meeting.",
      description: "Last day of project submission for last year.",
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 2)),
      startTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          14),
      endTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          16),
      title: "Team Meeting",
      description: "Team Meeting",
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 2)),
      startTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          10),
      endTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          12),
      title: "Chemistry Viva",
      description: "Today is Joe's birthday.",
    ),
  ];

/*

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.workWeek,
      onTap: calendarTapped,
      dataSource: MeetingDataSource(_getDataSource()),
      timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 6, endHour: 18, nonWorkingDays: <int>[DateTime.sunday]),
    ));
  }
  */

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

  CalendarController _controller = CalendarController();
  String? _text = '', _titleText = '';
  Color? _headerColor, _viewHeaderColor, _calendarColor;

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.header) {
      _text = DateFormat('MMMM yyyy').format(details.date!).toString();
      _titleText = 'Header';
    } else if (details.targetElement == CalendarElement.viewHeader) {
      _text = DateFormat('EEEE dd, MMMM yyyy').format(details.date!).toString();
      _titleText = 'View Header';
    } else if (details.targetElement == CalendarElement.calendarCell) {
      _text = DateFormat('EEEE dd, MMMM yyyy').format(details.date!).toString();
      _titleText = 'Calendar cell';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" $_titleText"),
            content: Text(" $_text"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('close'))
            ],
          );
        });
  }

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
        task: "Tomato Transplanting & Manure Spread",
        commencement: DateTime(2025, 01, 15, 6),
        duration: const Duration(minutes: 360)),
    Scheduler(
        division: "6746QQ1",
        task: "NPK Side Placing & Irrigation Extension",
        commencement: DateTime(2025, 01, 15, 12, 20),
        duration: const Duration(minutes: 100)),
    Scheduler(
        division: "6746QQ1",
        task: "Bamboo Cutting",
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
