import 'package:flutter/material.dart';
import 'models/note_model.dart';
import 'database_helper.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.insertNote(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    _notes = await DatabaseHelper.instance.fetchNotes();
    notifyListeners();
  }
}
