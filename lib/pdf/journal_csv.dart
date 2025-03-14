import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:inventaire_cnas/controllers/database_controller.dart';
import 'package:inventaire_cnas/controllers/affectation_controller.dart';
import 'package:inventaire_cnas/models/article.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class JournalCSV {
  final DatabaseController dbController = Get.find<DatabaseController>();
  final AffectationController affectationController =
      Get.find<AffectationController>();

  /// Generates a CSV file of stock movements.
  /// [searchQuery], [startDate], and [endDate] are used as filters, and are included in the CSV header.
  Future<void> generateCSV(
      {List<Map<String, dynamic>>? movements,
      String? searchQuery,
      DateTime? startDate,
      DateTime? endDate}) async {
    List<List<String>> csvData = [];

    // Header Section with Filter Options
    csvData.add(["CNAS - Journal du Stock"]);
    csvData.add(["Filtre Article: ${searchQuery ?? ''}"]);
    csvData.add([
      "Période: ${(startDate != null ? DateFormat('dd/MM/yyyy').format(startDate) : 'Début')} - "
          "${(endDate != null ? DateFormat('dd/MM/yyyy').format(endDate) : 'Fin')}"
    ]);
    csvData.add([""]); // Empty row

    // Table Header
    csvData.add(["Article", "Mouvement", "Quantité", "Date"]);

    // Build movements list from commandes (Ajouté) and affectationUnits (Sortie)

    // Add "Commande" movements (stock added)

    // Apply filters if provided
    if (searchQuery != null && searchQuery.isNotEmpty) {
      movements = movements!.where((m) {
        Article? article = m["article"];
        if (article == null) return false;
        return article.articleName
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }
    if (startDate != null) {
      movements = movements!.where((m) {
        try {
          DateTime mDate = DateTime.parse(m["date"]);
          return mDate.isAfter(startDate) || mDate.isAtSameMomentAs(startDate);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    if (endDate != null) {
      movements = movements!.where((m) {
        try {
          DateTime mDate = DateTime.parse(m["date"]);
          return mDate.isBefore(endDate) || mDate.isAtSameMomentAs(endDate);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // Sort movements by date
    movements!.sort((a, b) => a["date"].compareTo(b["date"]));

    // Build CSV rows
    for (var movement in movements) {
      Article? article = movement["article"];
      if (article == null) continue;
      csvData.add([
        article.articleName,
        movement["type"],
        movement["quantity"].toString(),
        movement["date"],
      ]);
    }

    // Convert CSV data to string
    String csvContent = const ListToCsvConverter(fieldDelimiter: ';', eol: '\n')
        .convert(csvData);

    // Save CSV file to Documents folder
    await _saveCSVToFile(csvContent);
  }

  Future<void> _saveCSVToFile(String csvContent) async {
    // Use getApplicationDocumentsDirectory or getDownloadsDirectory if available
    final Directory directory = await getApplicationDocumentsDirectory();
    final String timestamp =
        DateFormat('dd_MM_yyyy_HH_mm').format(DateTime.now());
    final String path = "${directory.path}/journal_du_stock_$timestamp.csv";
    final File file = File(path);
    await file.writeAsString(csvContent, flush: true, encoding: utf8);
    print("CSV généré : $path");
    // Optionally, open the file automatically using a package like open_file
  }
}
