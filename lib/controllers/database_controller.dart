import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/SQL/db_designation.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:inventaire_cnas/models/designation.dart';

class DatabaseController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Observables for the data
  var designations = <Designation>[];
  var articles = <Article>[];
  Designation? selectedDesignation;
  TextEditingController designationNameController = TextEditingController();
  //add prix and tva and ,articlenom controllers
  TextEditingController articleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceHTController = TextEditingController();
  TextEditingController tvaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDesignations();
    fetchArticles();
  }

  // Fetch all designations from the database
  void fetchDesignations() async {
    final data = await _dbHelper.getDesignations();
    designations = data;
  }

  // Fetch all articles from the database
  void fetchArticles() async {
    final data = await _dbHelper.getArticles();
    articles = data;
    update();
  }

  // Add a new designation
  Future<void> addDesignation() async {
    Designation designation = Designation(name: designationNameController.text);
    await _dbHelper.insertDesignation(designation);
    fetchDesignations();
  }

  // Add a new article
  Future<void> addArticle() async {
    Article article = Article(
        designationName: selectedDesignation!.name,
        description: "description",
        quantity: 15,
        priceHT: 5,
        montantHT: 5,
        tva: double.parse(tvaController.text),
        montantTTC: 565);
    await _dbHelper.insertArticle(article);
    fetchArticles();
  }

  // a function that extracts all the names of the designations from designations list
  List<String> getDesignationNames() {
    return designations.map((designation) => designation.name).toList();
  }
}
