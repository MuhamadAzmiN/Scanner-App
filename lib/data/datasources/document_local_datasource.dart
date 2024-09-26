import 'package:sqflite/sqflite.dart';
import '../models/document_model.dart';

class DocumentLocalDatasource {
  // Private constructor for singleton pattern
  DocumentLocalDatasource._init();

  // Singleton instance
  static final DocumentLocalDatasource instance =
      DocumentLocalDatasource._init();

  final String tableDocuments = 'documents';
  Database? _database;

  // Method to create table in the database
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableDocuments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      path TEXT,
      category TEXT,
      createdAt TEXT
    )
    ''');
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    // Get the path to the database folder
    final dbPath = await getDatabasesPath();
    // Properly concatenate the path
    final path = '$dbPath/$filePath';

    // Open and return the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Getter for the database instance
  Future<Database> get database async {
    // Return the existing database instance if available
    if (_database != null) return _database!;

    // Otherwise, initialize the database
    _database = await _initDB('documentscan.db');
    return _database!;
  }

  // Save a document into the database
  Future<void> saveDocument(DocumentModel document) async {
    final db = await instance.database;
    await db.insert(tableDocuments, document.toMap());
  }

  // Get all documents from the database, ordered by creation date
  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await instance.database;
    final result = await db.query(tableDocuments, orderBy: 'createdAt DESC');
    // Convert the result into a list of DocumentModel objects
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }

  // Get documents by category from the database
  Future<List<DocumentModel>> getDocumentByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      tableDocuments,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    // Convert the result into a list of DocumentModel objects
    return result.map((map) => DocumentModel.fromMap(map)).toList();
  }
}
