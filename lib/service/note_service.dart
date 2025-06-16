import '../db/note_database.dart';
import '../models/note_model.dart';

class NoteService {
  // Tambah note ke database
  Future<int> insertNote(Note note) async {
    final db = await NoteDatabase.instance.database;
    return await db.insert('notes', note.toMap());
  }

  // Ambil semua note dari database
  Future<List<Note>> getAllNotes() async {
    final db = await NoteDatabase.instance.database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Update note berdasarkan id
  Future<int> updateNote(Note note) async {
    final db = await NoteDatabase.instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Hapus note berdasarkan id
  Future<int> deleteNote(int id) async {
    final db = await NoteDatabase.instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
