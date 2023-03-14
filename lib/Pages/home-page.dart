import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laboratoriska/Model/termin.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Widgets/notification.dart';
import '../Widgets/nov_termin.dart';
import '../auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late DataSource _events;
  final User? user = Auth().currentUser;

  @override
  void initState() {
    _events = DataSource(_termini);
    NotificationApi.init(initScheduled: true);
    super.initState();
  }

  final List<Termin> _termini = [
    Termin(id: 0,
        predmet: "Bazi na podatoci",
        datumOd: DateTime.parse('2023-03-22 14:00'),
        datumDo: DateTime.parse('2023-03-22 16:00')),
    Termin(id: 1,
        predmet: "Menadzment na informaciski sistemi",
        datumOd: DateTime.parse('2023-03-22 08:30'),
        datumDo: DateTime.parse('2023-03-22 10:30')),
    Termin(id: 2,
        predmet: "Programiranje video igri",
        datumOd: DateTime.parse('2023-03-26 20:00'),
        datumDo: DateTime.parse('2023-03-26 22:00')),
    Termin(id: 3,
        predmet: "Mobilni informaciski sistemi",
        datumOd: DateTime.parse('2023-03-03 02:15'),
        datumDo: DateTime.parse('2023-03-03 04:00')),
  ];

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NovTermin(_addNewTerminToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewTerminToList(Termin termin) {
    setState(() {
      _termini.add(termin);
      _events = DataSource(_termini);
      NotificationApi.scheduleNotification(
        title: termin.predmet,
        body: 'Your exam for the subject ${termin.predmet} is starting in about 30 minutes time',
        scheduledDate: termin.datumOd.subtract(Duration(minutes: 30)),
      );
    });
  }

  void _deleteTermin(Object? id) {
    setState(() {
      _termini.removeWhere((element) => element.id == id);
      _events = DataSource(_termini);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text("Exam Schedules"),
        actions: <Widget>[
          IconButton(
            onPressed: () => _addItemFunction(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView (child: Center(
        child: Column(
          children: [
            Container(
              height: 400,
              child: _termini.isEmpty
                  ? Text("No exams scheduled")
                  : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(_termini[index].predmet, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${_termini[index].datumOd}"),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTermin(_termini[index].id)),
                        ));
                  },
                  itemCount: _termini.length),
            ),
            SfCalendar(
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              cellBorderColor: Colors.transparent,
              dataSource: _events,
            ),
            Text(user?.email ?? 'User email'),
            ElevatedButton(
              onPressed: signOut,
              child: const Text('Sign Out'),
            ),
        ],
      )
    ),
      )
    );
  }
}

Future<void> signOut() async {
  await Auth().signOut();
}

class DataSource extends CalendarDataSource {
  DataSource(List<Termin> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].datumOd;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].datumDo;
  }

  @override
  String getSubject(int index) {
    return appointments![index].predmet as String;
  }

  @override
  Object? getId(int index) {
    return appointments![index].id;
  }
}