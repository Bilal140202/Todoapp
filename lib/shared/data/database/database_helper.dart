import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "../constants/app_constants.dart";

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  
  DatabaseHelper._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);
    
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }
  
  Future _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE ${AppConstants.notesTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        plainContent TEXT NOT NULL,
        color INTEGER DEFAULT 0,
        categoryId TEXT,
        isPinned INTEGER DEFAULT 0,
        isFavorite INTEGER DEFAULT 0,
        isArchived INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        reminderTime TEXT,
        tags TEXT
      )
    """);
    
    await db.execute("""
      CREATE TABLE ${AppConstants.categoriesTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER DEFAULT 0,
        icon INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    """);
    
    await db.execute("""
      CREATE TABLE ${AppConstants.trashTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        plainContent TEXT NOT NULL,
        color INTEGER DEFAULT 0,
        categoryId TEXT,
        isPinned INTEGER DEFAULT 0,
        isFavorite INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        deletedAt TEXT NOT NULL,
        tags TEXT
      )
    """);
    
    await _insertDefaultCategories(db);
  }
  
  Future _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {"id": "personal", "name": "Personal", "color": 4280391411, "icon": 983551, "createdAt": DateTime.now().toIso8601String()},
      {"id": "work", "name": "Work", "color": 4284513675, "icon": 983743, "createdAt": DateTime.now().toIso8601String()},
      {"id": "ideas", "name": "Ideas", "color": 4284955319, "icon": 983927, "createdAt": DateTime.now().toIso8601String()},
      {"id": "shopping", "name": "Shopping", "color": 4286141768, "icon": 983902, "createdAt": DateTime.now().toIso8601String()},
    ];
    
    for (final category in defaultCategories) {
      await db.insert(AppConstants.categoriesTable, category);
    }
  }
  
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {}
  
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
