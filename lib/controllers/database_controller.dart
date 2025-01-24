import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/commende.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';
import 'package:inventaire_cnas/page/add_article.dart';

class DatabaseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observables for the data
  
  var allDesignations = <Designation>[];
  var allArticles = <Article>[];
  var allFournisseurs = <Fournisseur>[];
  var allBonDeCommendes = <BonDeCommende>[];

var designations = <Designation>[];
  var articles = <Article>[];
  var fournisseurs = <Fournisseur>[];
  List<Commende> commendes = [];
  List<BonDeCommende> bonDeCommendes = [];

  Commende? selectedCommende;
  Designation? selectedDesignation;
  Fournisseur? selectedFournisseur;
  BonDeCommende? selectedBonDeCommende;

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
    fetchAllArticles();
    fetchAllFournisseurs();
    fetchAllBonDeCommendes();
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

  void fetchAllArticles() async {
    final data = await _dbHelper.getArticles();
    allArticles = data;
  }

  void fetchAllFournisseurs() async {
    final data = await _dbHelper.getFournisseurs();
    allFournisseurs = data;
  }

  void fetchAllBonDeCommendes() async {
    final data = await _dbHelper.getBonDeCommendes();
    allBonDeCommendes = data;
  }


  String getDesignationNameByid(int idddd) {
// Find the designation with the matching id
    var designation = allDesignations.firstWhere(
      (d) => d.id == idddd,
      // Return 'Unknown' if not found
    );

    return designation.name;
  }

  Article getArticleById(int id) {
    return allArticles.firstWhere((article) => article.id == id);
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

  // update BonDeCommende

  void updateBonDeCommende() async {
    BonDeCommende bonDeCommende = BonDeCommende(
      id: selectedBonDeCommende!.id,
      date: selectedBonDeCommende!.date,
      fournisseur_id: selectedFournisseur!.id!,
      dateBonDeCommende: selectedBonDeCommende!.dateBonDeCommende,
      montantTotal: selectedBonDeCommende!.montantTotal,
    );
    await _dbHelper.updateBonDeCommende(bonDeCommende);
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

  void deleteCommende() async {
    await _dbHelper.deleteCommende(selectedCommende!.id!);
    fetchCommendes();
  }
  
  void fetchCommendes() async {
    final data = await _dbHelper.getCommendes();
    commendes = data;
    update();
  }

  
}
