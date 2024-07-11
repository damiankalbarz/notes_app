import 'package:flutter/material.dart';
import 'package:notatki_app/notes_provider.dart';
import 'package:provider/provider.dart';

import 'notes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider()..fetchNotes(),
      child: MaterialApp(
        title: 'Notatki',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotesPage(),
      ),
    );
  }
}

