import 'package:flutter/material.dart';
import 'package:note_taking_app/database/database_helper.dart';
import 'package:note_taking_app/models/note.dart';

void main() {
  runApp(MaterialApp(
    title: "Notes App",
    home: NotesList(),
  ));
}

class NotesList extends StatefulWidget {

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  String notes = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              color: Colors.white,
              child: Text('Insert Data'),
              onPressed: () {
                _insertNote();
              },
            ),
            Text(notes)
          ],
        ),
      ),
    );
  }

  void _insertNote() async {
    var db = new DatabaseHelper();
    var c = await db.insertNote(Note('a', 'b'));
    print(c);
  }

  void getAll() async {
    var db = new DatabaseHelper();
    var c = await db.getAllNotes();
    
  }
}
