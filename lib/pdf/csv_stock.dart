import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:path_provider/path_provider.dart';

class CSVStock {
  static Future<void> generateCSV(DatabaseController dbController) async {
    List<List<dynamic>> data = [
      [
        "Article Name",
        "Description",
        "Quantity",
        "Price HT",
        "TVA",
        "Montant TTC"
      ]
    ];

    for (var article in dbController.articles) {
      data.add([
        article.articleName,
        article.description,
        article.quantity,
        article.priceHT,
        article.tva,
        (article.priceHT * article.tva / 100 + article.priceHT) *
            article.quantity,
      ]);
    }

    String csvData = const ListToCsvConverter(
      fieldDelimiter: ";", // Change delimiter for Excel compatibility
      eol: "\n", // Ensure correct line endings
      textDelimiter: '"', // Ensure text fields are correctly formatted
    ).convert(data);

    final directory =
        Directory("C:/Users/${Platform.environment['USERNAME']}/Documents");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final file = File("${directory.path}/stock_articles.csv");
    try {
      await file.writeAsString(csvData,
          mode: FileMode.write, flush: true, encoding: utf8);
    } catch (e) {
      // Using Get package to show the snackbar
      Get.snackbar(
        'Error',
        'Error writing CSV file: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
