import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';
import 'package:moon_app/JsonStruct.dart';

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
  String tmp = "header";
  Map<DateTime, List> moon_list = {};
  int getHashCode(DateTime key) {return key.day * 1000000 + key.month * 10000 + key.year;}

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void getMoonList() async{
    var uri = Uri.parse('https://w4hirod1wb.execute-api.us-east-1.amazonaws.com/default/getMoonList');
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(res.body);
        var data = MoonList.fromJson(map);
        setState(() {
          for(var item in data.results){
            moon_list.addAll({DateTime.parse(item.date.toString()): ["check"]});
          }
        });
    } else {
        throw Exception('Failed to load post');
    }
  }

  void updateMoonList(String date) async{
    //var uri = Uri.parse('https://o5m83blpl3.execute-api.us-east-1.amazonaws.com/rel/?date=' + date);
    var uri = Uri.parse('https://o5m83blpl3.execute-api.us-east-1.amazonaws.com/rel/?date=2022');
    setState(() {tmp = "loading";});
    http.Response res = await http.get(uri);
    setState(() {tmp = "loading...";});
    if (res.statusCode == 200) {
        setState(() {tmp = "ok!!!";});
    } else {
        setState(() {tmp = "error!!!";});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 表示データ取得
    getMoonList();
    final moon = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(moon_list);
    List getEventForDay(DateTime day) {return moon[day] ?? [];}

    // マーカー
    Widget _buildEventsMarker(DateTime date, List events) {
      final item = events.first ?? '';
      _scheduleText(String schedule) {
        if (schedule == 'check') {
          return const Icon(
            Icons.favorite, 
            color: Colors.yellow,
            size: 10
          );
        }else {
          return const Text('');
        }
      }
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [_scheduleText(item),],
        ),
      );
    }

    // カレンダー
    Widget _buildCalendar(){
      return TableCalendar(
        locale: 'ja_JP',
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
        ),
        firstDay: DateTime.utc(2021, 3, 24),
        lastDay: DateTime.utc(2050, 12, 31),
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
          updateMoonList("2022-02-10 00:00:00");
        },
        onPageChanged: (focusedDay) {_focusedDay = focusedDay;},
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {return _buildEventsMarker(date, events);}
          },
        )
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(tmp)),
        backgroundColor: Colors.pinkAccent,
        body: _buildCalendar(),
      ),
    );
  }
}