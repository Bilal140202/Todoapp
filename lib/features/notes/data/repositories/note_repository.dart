import "package:sqflite/sqflite.dart";
import "../../../../shared/data/database/database_helper.dart";
import "../../../../shared/core/constants/app_constants.dart";
import "../../domain/models/note.dart";

class NoteRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Note>> getAllNotes() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.notesTable,
      where: "isArchived = ?",
      whereArgs: [0],
      orderBy: "isPinned DESC, updatedAt DESC",
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> getFavoriteNotes() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.notesTable,
      where: "isFavorite = ? AND isArchived = ?",
      whereArgs: [1, 0],
      orderBy: "isPinned DESC, updatedAt DESC",
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> getArchivedNotes() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.notesTable,
      where: "isArchived = ?",
      whereArgs: [1],
      orderBy: "updatedAt DESC",
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<Note?> getNoteById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.notesTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertNote(Note note) async {
    final db = await _databaseHelper.database;
    await db.insert(
      AppConstants.notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note note) async {
    final db = await _databaseHelper.database;
    await db.update(
      AppConstants.notesTable,
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final note = await getNoteById(id);
    if (note != null) {
      await _moveToTrash(note);
    }
    final db = await _databaseHelper.database;
    await db.delete(
      AppConstants.notesTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> _moveToTrash(Note note) async {
    final db = await _databaseHelper.database;
    final trashMap = {
      ...note.toMap(),
      "deletedAt": DateTime.now().toIso8601String(),
    };
    await db.insert(AppConstants.trashTable, trashMap);
  }

  Future<void> togglePin(String id) async {
    final note = await getNoteById(id);
    if (note != null) {
      await updateNote(note.copyWith(isPinned: !note.isPinned));
    }
  }

  Future<void> toggleFavorite(String id) async {
    final note = await getNoteById(id);
    if (note != null) {
      await updateNote(note.copyWith(isFavorite: !note.isFavorite));
    }
  }

  Future<void> toggleArchive(String id) async {
    final note = await getNoteById(id);
    if (note != null) {
      await updateNote(note.copyWith(isArchived: !note.isArchived));
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.notesTable,
      where: "(title LIKE ? OR plainContent LIKE ?) AND isArchived = ?",
      whereArgs: ["%$query%", "%$query%", 0],
      orderBy: "updatedAt DESC",
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
