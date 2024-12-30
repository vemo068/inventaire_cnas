import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';

class DatabaseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observables for the data
  var designations = <Designation>[].obs;
  var articles = <Article>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDesignations();
    fetchArticles();
  }

  // Fetch all designations from the database
  void fetchDesignations() async {
    final data = await _dbHelper.getDesignations();
    designations.value = data;
  }

  // Fetch all articles from the database
  void fetchArticles() async {
    final data = await _dbHelper.getArticles();
    articles.value = data;
  }

  // Add a new designation
  Future<void> addDesignation(Designation designation) async {
    await _dbHelper.insertDesignation(designation);
    fetchDesignations();
  }

  // Add a new article
  Future<void> addArticle(Article article) async {
    await _dbHelper.insertArticle(article);
    fetchArticles();
  }
}
