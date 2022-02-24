import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:collection';

void main() {
  initializeDateFormatting().then((_) => runApp(MainPage()));
}
class MainPage extends StatefulWidget{
  MyApp createState()=> MyApp();
}

class MyApp extends State<MainPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //サンプルのイベントリスト
    _eventsList = {
      DateTime.now().add(Duration(days: 2)): ['Event A6', 'Event B6'],
      DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      DateTime.parse('2022-02-01 00:00:00'): ["aaa"],
    };
  }
  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }   

    return MaterialApp(
      title: "MoonApp",
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Container(
          child: Column(
            children: [
              Center(
                child: TableCalendar(
                  locale: 'ja_JP',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  firstDay: DateTime.utc(2021, 3, 24),
                  lastDay: DateTime.utc(2050, 3, 24),
                  focusedDay: _focusedDay,
                  eventLoader: getEventForDay,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) {return isSameDay(_selectedDay, day);},
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {_focusedDay = focusedDay;},
                )
              ),
              Center(
                child: Text("aaa"),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
