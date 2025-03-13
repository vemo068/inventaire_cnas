import 'package:inventaire_cnas/SQL/tables.dart';
import 'package:inventaire_cnas/models/bon_affectation.dart';
import 'package:inventaire_cnas/models/affectation_unit.dart';
import 'package:inventaire_cnas/models/agent.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/commende.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String databaseName = "invtcnasbase13032025.db";

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
        await db.execute(servicesTable);
        await db.execute(affectationTable);
        await db.execute(affectationUnitTable);
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
  Future<int> updateBonDeCommende(BonDeCommende updatedBonDeCommende) async {
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

  // insert commende and update article quantity
  Future<int> insertCommende(Commende commende) async {
    final Database db = await init();
    await db.transaction((txn) async {
      // Insert the commende
      await txn.insert("commendes", commende.toJson());

      // Update the quantity of the article
      await txn.rawUpdate(
        "UPDATE articles SET quantity = quantity + ? WHERE id = ?",
        [commende.quantite, commende.article_id],
      );
    });
    return 1;
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
    // Get the commende to retrieve the article_id and quantity
    final List<Map<String, Object?>> commendeResult = await db.query(
      "commendes",
      where: "id = ?",
      whereArgs: [id],
    );

    if (commendeResult.isNotEmpty) {
      final Commende commende = Commende.fromJson(commendeResult.first);

      // Delete the commende
      await db.delete("commendes", where: "id = ?", whereArgs: [id]);

      // Update the quantity of the article
      return db.rawUpdate(
        "UPDATE articles SET quantity = quantity - ? WHERE id = ?",
        [commende.quantite, commende.article_id],
      );
    }

    return 0;
  }

  // CRUD Operations for Agents
  Future<int> insertService(ServiceC service) async {
    final db = await init();
    return await db.insert('services', service.toJson());
  }

  Future<List<ServiceC>> getServices() async {
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.query('services');
    return List.generate(maps.length, (i) => ServiceC.fromJson(maps[i]));
  }

  Future<int> updateService(ServiceC agent) async {
    final db = await init();
    return await db.update('services', agent.toJson(),
        where: 'id = ?', whereArgs: [agent.id]);
  }

  Future<int> deleteService(int id) async {
    final db = await init();
    return await db.delete('services', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Affectations
  Future<int> insertAffectation(BonAffectation affectation) async {
    final db = await init();
    int result = await db.insert('affectations', affectation.toJson());
    return result;
  }

  Future<List<BonAffectation>> getAffectations() async {
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.query('affectations');
    return List.generate(maps.length, (i) => BonAffectation.fromJson(maps[i]));
  }

  Future<int> deleteAffectation(int id) async {
    final db = await init();
    return await db.delete('affectations', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for AffectationUnits

  Future<int> insertAffectationUnit(AffectationUnit affectationUnit) async {
    final db = await init();
    //update the quantity of the article
    await db.rawUpdate(
      "UPDATE articles SET quantity = quantity - ? WHERE id = ?",
      [affectationUnit.quantity, affectationUnit.articleId],
    );
    return await db.insert('affectationUnits', affectationUnit.toJson());
  }

  Future<List<AffectationUnit>> getAffectationUnits() async {
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.query('affectationUnits');
    return List.generate(maps.length, (i) => AffectationUnit.fromJson(maps[i]));
  }

  Future<int> deleteAffectationUnit(int id) async {
    final db = await init();
    final List<Map<String, dynamic>> maps =
        await db.query('affectationUnits', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final AffectationUnit affectationUnit =
          AffectationUnit.fromJson(maps.first);
      //update the quantity of the article
      await db.rawUpdate(
        "UPDATE articles SET quantity = quantity + ? WHERE id = ?",
        [affectationUnit.quantity, affectationUnit.articleId],
      );
    }
    return await db
        .delete('affectationUnits', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAffectationUnit(AffectationUnit affectationUnit) async {
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.query('affectationUnits',
        where: 'id = ?', whereArgs: [affectationUnit.id]);
    if (maps.isNotEmpty) {
      final AffectationUnit oldAffectationUnit =
          AffectationUnit.fromJson(maps.first);
      //update the quantity of the article
      await db.rawUpdate(
        "UPDATE articles SET quantity = quantity + ? WHERE id = ?",
        [oldAffectationUnit.quantity, oldAffectationUnit.articleId],
      );
    }
    //update the quantity of the article
    await db.rawUpdate(
      "UPDATE articles SET quantity = quantity - ? WHERE id = ?",
      [affectationUnit.quantity, affectationUnit.articleId],
    );
    return await db.update('affectationUnits', affectationUnit.toJson(),
        where: 'id = ?', whereArgs: [affectationUnit.id]);
  }

  Future<List<AffectationUnit>> getAffectationUnitsByBonId(int bonAffectationId) async {
    final db = await init();
    final List<Map<String, dynamic>> maps = await db.query(
      'affectationUnits',
      where: 'affectation_id = ?',
      whereArgs: [bonAffectationId],
    );
    return List.generate(maps.length, (i) => AffectationUnit.fromJson(maps[i]));
  }
}
