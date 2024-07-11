import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notes_provider.dart';
import 'models/note_model.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';



class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notatki'),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.isVoice ? 'Notatka głosowa' : note.content),
                onTap: () {
                  if (note.isVoice) {
                    _player.startPlayer(
                      fromURI: note.content,
                      codec: Codec.aacADTS,
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  FlutterSoundRecorder? _recorder;
  bool isRecording = false;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _recorder!.openRecorder();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    filePath = 'note_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );
    setState(() {
      isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj notatkę'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Treść'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRecording ? _stopRecording : _startRecording,
              child: Text(isRecording ? 'Zatrzymaj nagrywanie' : 'Nagrywaj'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final content = filePath ?? contentController.text;

                final note = Note(
                  title: title,
                  content: content,
                  isVoice: filePath != null,
                );

                Provider.of<NotesProvider>(context, listen: false).addNote(note);

                Navigator.pop(context);
              },
              child: Text('Dodaj notatkę'),
            ),
          ],
        ),
      ),
    );
  }
}