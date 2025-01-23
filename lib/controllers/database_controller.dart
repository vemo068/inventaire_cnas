import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';
import 'package:inventaire_cnas/page/add_article.dart';

class DatabaseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observables for the data
  var designations = <Designation>[];
  var allDesignations = <Designation>[];
  var articles = <Article>[];
  var fournisseurs = <Fournisseur>[];
  List<BonDeCommende> bonDeCommendes = [];
  Designation? selectedDesignation;
  Fournisseur? selectedFournisseur;
  TextEditingController designationNameController = TextEditingController();
  //add prix and tva and ,articlenom controllers
  TextEditingController articleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceHTController = TextEditingController();
  TextEditingController tvaController = TextEditingController();
  TextEditingController fournisseurController = TextEditingController();

  TextEditingController articleSearchController = TextEditingController();

  var selectedValue;

  @override
  void onInit() {
    super.onInit();
    fetchDesignations();
    fetchArticles();
    fetchBonDeCommendes();
    fetchFournisseurs();
    fetchAllDesignations();
  }

  // Fetch all designations from the database
  void fetchDesignations() async {
    final data = await _dbHelper.getDesignations();
    designations = data;
  }

  void fetchBonDeCommendes() async {
    final data = await _dbHelper.getBonDeCommendes();
    bonDeCommendes = data;
  }

  void fetchAllDesignations() async {
    final data = await _dbHelper.getDesignations();
    allDesignations = data;
  }

  String getDesignationNameByid(int idddd) {
// Find the designation with the matching id
    var designation = allDesignations.firstWhere(
      (d) => d.id == idddd,
      // Return 'Unknown' if not found
    );

    return designation.name;
  }

  // Fetch all articles from the database
  void fetchArticles() async {
    final data = await _dbHelper.getArticles();
    articles = data;
    update();
  }

  void filterArticles() async {
    final data = await _dbHelper.filterArticles(articleSearchController.text);
    articles = data;
    update();
  }

  void filterArticlesByDesignation() async {
    if (selectedDesignation == null) {
      fetchArticles();
    } else {
      final data =
          await _dbHelper.filterArticlesByDesignation(selectedDesignation);
      articles = data;
    }

    update();
  }

  // Add a new designation
  Future<void> addDesignation() async {
    Designation designation = Designation(name: designationNameController.text);
    await _dbHelper.insertDesignation(designation);
    fetchDesignations();
    fetchAllDesignations();
    update();
  }

// Add a new fournisseur
  Future<void> addFournisseur() async {
    Fournisseur fournisseur = Fournisseur(name: fournisseurController.text);
    await _dbHelper.insertFournisseur(fournisseur);
    fetchFournisseurs();
    update();
  }

  // Add a new article
  Future<void> addArticle() async {
    Article article = Article(
        articleName: articleNameController.text,
        designation_id: selectedDesignation!.id!,
        description: descriptionController.text,
        quantity: int.parse(quantityController.text),
        priceHT: double.parse(priceHTController.text),
        montantHT: int.parse(quantityController.text) *
            double.parse(priceHTController.text),
        tva: double.parse(tvaController.text),
        montantTTC: int.parse(quantityController.text) *
            double.parse(priceHTController.text) *
            double.parse(tvaController.text));
    await _dbHelper.insertArticle(article);
    fetchArticles();
  }

  // Add a new bon de commendes
  void addBonDeCommende() async {
    BonDeCommende bonDeCommende = BonDeCommende(
      date: DateTime.now().toString(),
      fournisseur_id: selectedFournisseur!.id!,
      dateBonDeCommende: DateTime.now(),
      montantTotal: 0.0,
    );
    await _dbHelper.insertBonDeCommende(bonDeCommende);
    fetchBonDeCommendes();
  }

  // a function that extracts all the names of the designations from designations list
  List<String> getDesignationNames() {
    return designations.map((designation) => designation.name).toList();
  }

  void fetchFournisseurs() async {
    final data = await _dbHelper.getFournisseurs();
    fournisseurs = data;
    update();
  }

  void goToAddArticle() async {
    Get.to(() => AddArticlePage());
  }
}
