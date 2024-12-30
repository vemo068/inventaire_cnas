import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  final String databaseName = "appDatabase.db";

  // SQL to create the Designation table
  final String designationTable = '''
  CREATE TABLE designations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''';

  // SQL to create the Article table
  final String articleTable = '''
  CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    designationName TEXT NOT NULL,
    description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    priceHT REAL NOT NULL,
    montantHT REAL NOT NULL,
    tva REAL NOT NULL,
    montantTTC REAL NOT NULL,
    FOREIGN KEY (designationName) REFERENCES designations(name)
  )''';

  // Database connection initialization
  Future<Database> init() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = join(databasePath.path, databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute(designationTable);
        await db.execute(articleTable);
      },
    );
  }

  // CRUD Methods for Designations

  Future<List<Designation>> getDesignations() async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.query("designations");
    return result.map((e) => Designation.fromJson(e)).toList();
  }

  Future<int> insertDesignation(Designation designation) async {
    final Database db = await init();
    return db.insert("designations", designation.toJson());
  }

  Future<int> updateDesignation(int id, String newName) async {
    final Database db = await init();
    return db.rawUpdate(
      "UPDATE designations SET name = ? WHERE id = ?",
      [newName, id],
    );
  }

  Future<int> deleteDesignation(int id) async {
    final Database db = await init();
    return db.delete("designations", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Designation>> filterDesignations(String keyword) async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT * FROM designations WHERE name LIKE ?",
      ["%$keyword%"],
    );
    return result.map((e) => Designation.fromJson(e)).toList();
  }

  // CRUD Methods for Articles

  Future<List<Article>> getArticles() async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.query("articles");
    return result.map((e) => Article.fromJson(e)).toList();
  }

  Future<int> insertArticle(Article article) async {
    final Database db = await init();
    return db.insert("articles", article.toJson());
  }

  Future<int> updateArticle(int id, Article updatedArticle) async {
    final Database db = await init();
    return db.update(
      "articles",
      updatedArticle.toJson(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteArticle(int id) async {
    final Database db = await init();
    return db.delete("articles", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Article>> filterArticles(String keyword) async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT * FROM articles WHERE description LIKE ?",
      ["%$keyword%"],
    );
    return result.map((e) => Article.fromJson(e)).toList();
  }
}
