import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

//testing worrk
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = Firestore.instance;
  String task;

  void showPopUp() {
    final _fromKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Todo'),
            content: Form(
              key: _fromKey,
              child: TextFormField(
                autovalidate: true,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task',
                ),
                validator: (_value) {
                  if (_value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (_value) {
                  task = _value;
                },
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  db.collection('tasks').add({'name': task});
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showPopUp,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Working'),
      ),
      body: Container(
        child: Text('Working'),
      ),
    );
  }
}
