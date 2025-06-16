import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  // Singleton agar instance database hanya dibuat sekali
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  // Getter untuk mendapatkan database. Jika belum ada, buat baru.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('kodein_notes.db');
    return _database!;
  }

  // Inisialisasi database dan menentukan path-nya
  Future<Database> _initDB(String fileName) async {
    final dbPath =
        await databaseFactory.getDatabasesPath(); // path folder database
    final path = join(dbPath, fileName); // path lengkap file database

    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createDB, // fungsi untuk membuat tabel saat pertama kali
        ));
  }

  // Buat tabel notes dengan kolom yang dibutuhkan
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        dateTime TEXT,
        image TEXT
      )
    ''');
  }
}
