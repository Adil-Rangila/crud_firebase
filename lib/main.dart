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

  void showPopUp(bool isUpdate, DocumentSnapshot ds) {
    final _fromKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: isUpdate ? Text('Update Todo') : Text('Add Todo'),
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
                  if (isUpdate) {
                    db
                        .collection('tasks')
                        .document(ds.documentID)
                        .updateData({'name': task});
                  } else {
                    db
                        .collection('tasks')
                        .add({'name': task, 'time': DateTime.now()});
                  }
                  Navigator.pop(context);
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
        onPressed: () => showPopUp(false, null),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Working'),
      ),
      body: Container(
        //through this i am receivng value from database thanks to stream builder and snapshot
        child: StreamBuilder<QuerySnapshot>(
          stream: db.collection('tasks').orderBy('time').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return ListTile(
                      title: Text(ds['name']),
                      onLongPress: () {
                        //this will delete the feild in tha could firestore...
                        db.collection('tasks').document(ds.documentID).delete();
                      },
                      onTap: () {
                        //this part is use for updating data in firebase.
                        showPopUp(true, ds);
                      },
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
