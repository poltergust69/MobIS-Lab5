import 'package:flutter/material.dart';
import 'package:laboratoriska/Model/termin.dart';
import '../Widgets/nov_termin.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {

    super.initState();
  }

  final List<Termin> _termini = [
    Termin(id: 0,
        predmet: "Bazi na podatoci",
        datumOd: DateTime.parse('2023-02-22 14:00'),
        datumDo: DateTime.parse('2023-02-22 16:00')),
    Termin(id: 1,
        predmet: "Menadzment na informaciski sistemi",
        datumOd: DateTime.parse('2023-02-22 08:30'),
        datumDo: DateTime.parse('2023-02-22 10:30')),
    Termin(id: 2,
        predmet: "Programiranje video igri",
        datumOd: DateTime.parse('2023-02-26 20:00'),
        datumDo: DateTime.parse('2023-02-26 22:00')),
    Termin(id: 3,
        predmet: "Mobilni informaciski sistemi",
        datumOd: DateTime.parse('2023-02-03 02:15'),
        datumDo: DateTime.parse('2023-02-03 04:00')),
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
    });
  }

  void _deleteTermin(Object? id) {
    setState(() {
      _termini.removeWhere((element) => element.id == id);
      // _events = DataSource(_termini);
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
              height: 800,
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
        ],
      )
    ),
      )
    );
  }
}