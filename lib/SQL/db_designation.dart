import 'package:inventaire_cnas/SQL/tables.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/commende.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String databaseName = "invtcnasbase.db";

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
        await db.execute(fournisseurTable);
        await db.execute(bonDeCommendeTable);
        await db.execute(commendeTable);
      },
    );
  }

  //create CRUD Methods for fournisseur
  Future<List<Fournisseur>> getFournisseurs() async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.query("fournisseurs");
    return result.map((e) => Fournisseur.fromJson(e)).toList();
  }

  Future<int> insertFournisseur(Fournisseur fournisseur) async {
    final Database db = await init();
    return db.insert("fournisseurs", fournisseur.toJson());
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
      "SELECT * FROM articles WHERE articleName LIKE ?",
      ["%$keyword%"],
    );
    return result.map((e) => Article.fromJson(e)).toList();
  }

  Future<List<Article>> filterArticlesByDesignation(
      Designation? selectedDesignation) async {
    final Database db = await init();
    int desId = selectedDesignation!.id!;
    final List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT * FROM articles WHERE designation_id = $desId",
    );
    return result.map((e) => Article.fromJson(e)).toList();
  }

  // insert bondecommende
  Future<int> insertBonDeCommende(BonDeCommende bonDeCommende) async {
    final Database db = await init();
    return db.insert("bonDeCommendes", bonDeCommende.toJson());
  }

  // get bondecommende
  Future<List<BonDeCommende>> getBonDeCommendes() async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.query("bonDeCommendes");
    return result.map((e) => BonDeCommende.fromJson(e)).toList();
  }

  // update bondecommende
  Future<int> updateBonDeCommende(
      BonDeCommende updatedBonDeCommende) async {
    final Database db = await init();
    return db.update(
      "bonDeCommendes",
      updatedBonDeCommende.toJson(),
      where: "id = ?",
      whereArgs: [updatedBonDeCommende.id],
    );
  }

  // delete bondecommende
  Future<int> deleteBonDeCommende(int id) async {
    final Database db = await init();
    return db.delete("bonDeCommendes", where: "id = ?", whereArgs: [id]);
  }

  // filter bondecommende
  Future<List<BonDeCommende>> filterBonDeCommendes(String keyword) async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT * FROM bonDeCommendes WHERE date LIKE ?",
      ["%$keyword%"],
    );
    return result.map((e) => BonDeCommende.fromJson(e)).toList();
  }


  // insert commende
  Future<int> insertCommende(Commende commende) async {
    final Database db = await init();
    return db.insert("commendes", commende.toJson());
  }

  // get commende
  Future<List<Commende>> getCommendes() async {
    final Database db = await init();
    final List<Map<String, Object?>> result = await db.query("commendes");
    return result.map((e) => Commende.fromJson(e)).toList();
  }

  // update commende
  Future<int> updateCommende(Commende updatedCommende) async {
    final Database db = await init();
    return db.update(
      "commendes",
      updatedCommende.toJson(),
      where: "id = ?",
      whereArgs: [updatedCommende.id],
    );
  }

  // delete commende
  Future<int> deleteCommende(int id) async {
    final Database db = await init();
    return db.delete("commendes", where: "id = ?", whereArgs: [id]);
  }
}
