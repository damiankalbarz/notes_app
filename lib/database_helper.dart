import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE notes (
      id $idType,
      title $textType,
      content $textType,
      isVoice $boolType
    )
    ''');
  }

  Future<void> insertNote(Note note) async {
    final db = await instance.database;

    await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Note>> fetchNotes() async {
    final db = await instance.database;

    final maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int?,
        title: maps[i]['title'] as String,
        content: maps[i]['content'] as String,
        isVoice: (maps[i]['isVoice'] as int) == 1,
      );
    });
  }
}
