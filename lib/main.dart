import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import "package:intl/intl.dart";
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
        moon_list = {};
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
    var uri = Uri.parse("https://o5m83blpl3.execute-api.us-east-1.amazonaws.com/rel/?date=" + date);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
        print("updateMoonList");
    } else {
    }
    getMoonList();
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
            color: Color.fromARGB(255, 213, 26, 44),
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
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: Color.fromARGB(255, 143, 81, 98)),
          rightChevronIcon: Icon(Icons.chevron_right, color: Color.fromARGB(255, 143, 81, 98)),
          titleTextStyle: TextStyle(color: Color.fromARGB(255, 143, 81, 98), fontSize: 20),
        ),
        firstDay: DateTime.utc(2021, 3, 24),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: _focusedDay,
        eventLoader: getEventForDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) {return isSameDay(_selectedDay, day);},
        onDaySelected: (selectedDay, focusedDay) {
          var formatter = new DateFormat('yyyyMMddHHmmss', "ja_JP");
          updateMoonList(formatter.format(selectedDay));
        },
        onPageChanged: (focusedDay) {_focusedDay = focusedDay;},
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {return _buildEventsMarker(date, events);}
          },
          dowBuilder: (context, day) {
            return Center(
              child: Text(
                DateFormat.E().format(day),
                style: TextStyle(color: Color.fromARGB(255, 143, 81, 98)),
              ),
            );
          },
          selectedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text(
                day.day.toString(),
                style: TextStyle(color: Color.fromARGB(255, 143, 81, 98), fontWeight: FontWeight.bold),
              ),
            );
          },
          defaultBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text(
                day.day.toString(),
                style: TextStyle(color: Color.fromARGB(255, 143, 81, 98), fontFamily: "PoppinsMedium"),
              ),
            );
          },
          disabledBuilder: (BuildContext context, DateTime day, DateTime focusedDay){
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text(
                day.day.toString(),
                style: TextStyle(color: Color.fromARGB(255, 143, 81, 98)),
              ),
            );
          }
        ),
      );
    }
    
    // ハーフモーダル
    Widget _buildModal(){
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              Text("aaa"),
            ],
          ),
        ),
      );
    }

    return MaterialApp(
      home: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/background.jpeg'),
                fit: BoxFit.cover,
              )
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: _buildCalendar(),
                  ),
                ],
              ),
            ),
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 143, 81, 98),
                child: Icon(Icons.nightlight_rounded),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (context) => _buildModal(),
                  );
                },
              ),
            )
          ),
        ],
      )
    );
  }
}