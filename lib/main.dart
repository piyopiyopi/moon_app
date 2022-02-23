import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MainPage()));
}
class MainPage extends StatefulWidget{
  MyApp createState()=> MyApp();
}

class MyApp extends State<MainPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MoonApp",
      theme: ThemeData.light(),
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Center(
                child: Container(
                  child: TableCalendar(
                    firstDay: DateTime.utc(1900, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                  )
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
