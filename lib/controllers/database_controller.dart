import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/bon_de_commende.dart';
import 'package:inventaire_cnas/models/commende.dart';
import 'package:inventaire_cnas/models/designation.dart';
import 'package:inventaire_cnas/models/fournisseur.dart';

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
  List<Commende> selectedComments = [];

  Commende? selectedCommende;
  Designation? selectedDesignation;
  Fournisseur? selectedFournisseur;
  BonDeCommende? selectedBonDeCommende;
  TextEditingController numuroBonDeCommendeController =
      TextEditingController(); // for the bon de commende

  TextEditingController designationNameController = TextEditingController();
  TextEditingController designationCompteController = TextEditingController();
  //add prix and tva and ,articlenom controllers
  TextEditingController articleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceHTController = TextEditingController();
  TextEditingController tvaController = TextEditingController();
  TextEditingController fournisseurController = TextEditingController();

  TextEditingController articleSearchController = TextEditingController();

  // l'ajoute d'une commende
  Article? selectedArticleForCommende;
  Designation? selectedDesignationForCommende;
  Fournisseur? selectedFournisseurForCommende;
  TextEditingController quantityControllerForCommende = TextEditingController();

  Article? selectedArticleToUpdate;

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

  String getDesignationCompteByid(int idddd) {
// Find the designation with the matching id
    var designation = allDesignations.firstWhere(
      (d) => d.id == idddd,
      // Return 'Unknown' if not found
    );

    return designation.compte;
  }

  Article getArticleById(int id) {
    return allArticles.firstWhere((article) => article.id == id);
  }

  // Fetch all articles from the database
  void fetchArticles() async {
    final data = await _dbHelper.getArticles();
    articles = data;
    fetchAllArticles();
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
    if (designationNameController.text == "" ||
        designationCompteController.text == "") {
      Get.snackbar("Error", "Please fill all the fields");
    } else {
      Designation designation = Designation(
          name: designationNameController.text,
          compte: designationCompteController.text);
      await _dbHelper.insertDesignation(designation);
      fetchDesignations();
      fetchAllDesignations();
      update();
      designationNameController.clear();
    }
  }

// Add a new fournisseur
  Future<void> addFournisseur() async {
    if (fournisseurController.text != "") {
      Fournisseur fournisseur = Fournisseur(name: fournisseurController.text);
      await _dbHelper.insertFournisseur(fournisseur);
      fetchFournisseurs();
      update();
      fournisseurController.clear();
    } else {
      Get.snackbar("Error", "Please fill all the fields");
    }
  }

  // Add a new article
  Future<void> addArticle() async {
    if (articleNameController.text == "" ||
        descriptionController.text == "" ||
        quantityController.text == "" ||
        priceHTController.text == "" ||
        tvaController.text == "" ||
        selectedDesignation == null) {
      Get.snackbar("Error", "Please fill all the fields");
    } else {
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
      articleNameController.clear();
      descriptionController.clear();
      quantityController.clear();
      priceHTController.clear();
      tvaController.clear();
      update();
    }
  }

  // Add a new bon de commendes
  void addBonDeCommende(DateTime picked_date) async {
    if (selectedFournisseur == null) {
      Get.snackbar("Error", "Please fill all the fields");
    } else {
      BonDeCommende bonDeCommende = BonDeCommende(
        numuroBonDeCommende: numuroBonDeCommendeController.text,
        date: picked_date.toString(),
        fournisseur_id: selectedFournisseur!.id!,
        dateBonDeCommende: picked_date,
        montantTotal: 0.0,
      );
      try {
        await _dbHelper.insertBonDeCommende(bonDeCommende);
      } on Exception catch (e) {
        // TODO
      }
      numuroBonDeCommendeController.clear();
      fetchBonDeCommendes();

      selectedFournisseur = null;
      update();
    }
  }

  // update BonDeCommende

  void updateBonDeCommende(double total) async {
    BonDeCommende bonDeCommende = BonDeCommende(
      id: selectedBonDeCommende!.id,
      date: selectedBonDeCommende!.date,
      numuroBonDeCommende: selectedBonDeCommende!.numuroBonDeCommende,
      fournisseur_id: selectedBonDeCommende!.fournisseur_id,
      dateBonDeCommende: selectedBonDeCommende!.dateBonDeCommende,
      montantTotal: selectedBonDeCommende!.montantTotal! + total,
    );
    await _dbHelper.updateBonDeCommende(bonDeCommende);
    selectedBonDeCommende = bonDeCommende;
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

  void fetchCommendes() async {
    final data = await _dbHelper.getCommendes();
    commendes = data;
    update();
  }

  void addCommende() async {
    //  selectedArticleToUpdate = allArticles
    // .firstWhere((element) => element.id == selectedArticleForCommende!.id);
    if (quantityControllerForCommende.text != "" &&
        selectedArticleForCommende != null) {
      double total = (selectedArticleForCommende!.priceHT *
              double.parse(quantityControllerForCommende.text)) *
          (selectedArticleForCommende!.tva / 100 + 1);

      Commende commende = Commende(
        article_id: selectedArticleForCommende!.id!,
        bonDeCommende_id: selectedBonDeCommende!.id!,
        quantite: int.parse(quantityControllerForCommende.text),
      );
      await _dbHelper.insertCommende(commende);
      updateBonDeCommende(total);
      //updateArticleAddingQuantity(commende.quantite);
      fetchCommendes();
      fetchArticles();
      quantityControllerForCommende.clear();
      selectedArticleForCommende = null;
      selectedDesignation = null;
      update();
    } else {
      Get.snackbar("Error", "Please fill all the fields");
    }
  }

  void removeCommende() async {
    selectedArticleToUpdate = allArticles
        .firstWhere((element) => element.id == selectedCommende!.article_id);
    double total = (selectedArticleToUpdate!.priceHT *
        selectedCommende!.quantite *
        (selectedArticleToUpdate!.tva / 100 + 1));
    await _dbHelper.deleteCommende(selectedCommende!.id!);
    updateBonDeCommende(-total);
    // updateArticleSubstractingQuantity(selectedCommende!.quantite);
    fetchCommendes();
    fetchArticles();
    update();
  }
}
